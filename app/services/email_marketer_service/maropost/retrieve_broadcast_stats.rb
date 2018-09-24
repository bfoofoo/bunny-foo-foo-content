module EmailMarketerService
  module Maropost
    class RetrieveBroadcastStats
      attr_reader :client

      EVENT_TYPES = %w(open click).freeze
      DEFAULT_DATE = Date.new(2018, 8, 1)

      def initialize(since: nil)
        @auth_services = {}
        @subscribers = {}
        @accounts = {}
        @contacts = {}
        @clients = {}
        @since = since || last_campaign_date
      end

      def call
        collect_campaigns
        collect_leads
      end

      private

      def collect_campaigns
        MaropostList.all.includes(:maropost_account).each do |list|
          @client = client_for(list.account)
          campaigns = client.campaigns.all.select { |c| c.status == 'sent' }
          campaigns.each { |campaign| find_or_create_campaign(campaign) }
        end
      rescue MaropostApi::Errors => e
        puts "Maropost campaigns fetch failed due to error: #{e.to_s}"
      end

      def find_or_create_campaign(campaign)
        EmailMarketerCampaign.find_or_initialize_by(origin: 'Maropost', campaign_id: campaign['id']) do |c|
          c.subject = campaign['subject']
          full_campaign = client.campaigns[campaign['id']]
          c.stats = {
            'sent' => full_campaign['sent'],
            'opens' => full_campaign['unique_opens'],
            'clicks' => full_campaign['unique_clicks']
          }
          c.sent_at = campaign['sent_at'] || campaign['send_at'] || campaign['created_at']
          c.list_ids = full_campaign['lists'].map(&:id)
        end.save
      end

      def collect_leads
        users.each do |user|
          @client = client_for(account_for(user.maropost_list))

          EVENT_TYPES.each do |event_type|
            events_by_type(event_type, user).each do |event|
              Leads::Maropost.find_or_create_by(lead_params(user, event, event_type)) do |lead|
                lead.email = user.email
                lead.event_at = event_campaign_sent_at(event)
              end
            end
          end
        end
      end

      def events_by_type(event_type, user)
        method = event_type.pluralize
        client
          .reports
          .send(method, maropost_report_params.merge('email' => user.email.downcase))
          .uniq { |o| o['campaign_id'] }
      rescue MaropostApi::Errors => e
        puts "Maropost reports fetch failed due to error: #{e.to_s}"
        []
      end

      def event_campaign_sent_at(event)
        campaign = client.campaigns[event['campaign_id']]
        campaign['sent_at'] || campaign['created_at']
      rescue MaropostApi::Errors
        puts "Maropost failed to fetch campaign #{event['campaign_id']} due to error: #{e.to_s}"
        nil
      end

      def users
        @users ||=
          User
            .added_to_maropost
            .joins(:formsite_users)
            .includes(:maropost_list, :leads, :formsite_users)
      end

      def account_for(list)
        @accounts[list.list_id] ||= list.account
      end

      def client_for(account)
        @clients[account.account_id] ||=
          MaropostApi::Client.new(auth_token: account.auth_token, account_number: account.account_id)
      end

      def contact_by_email(email)
        @contacts[email] ||= client.contacts.find_by_email(email: email)
      rescue MaropostApi::Errors => e
        puts "Maropost failed to fetch contact by email #{email}: #{e.to_s}"
      end

      def lead_params(user, event, event_type)
        affiliate = contact_by_email(user.email)&.[]('affiliate') || user.formsite_users.first.affiliate
        {
          source_id: user.maropost_list.id,
          affiliate: affiliate,
          status: event_type,
          user_id: user.id,
          campaign_id: event['campaign_id']
        }.compact
      end

      def maropost_report_params
        {
          'unique' => 'true',
          'from' => @since&.to_date&.to_s,
          'to' => Date.today
        }.compact
      end

      def last_campaign_date
        EmailMarketerCampaign.where(origin: 'Maropost').last&.sent_at || DEFAULT_DATE
      end
    end
  end
end
