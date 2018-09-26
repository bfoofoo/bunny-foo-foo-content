module EmailMarketerService
  module Maropost
    class RetrieveBroadcastStats
      attr_reader :client, :result

      EVENT_TYPES = %w(open click).freeze
      DEFAULT_DATE = Date.new(2018, 8, 1)

      def initialize(since: nil)
        @auth_services = {}
        @subscribers = {}
        @accounts = {}
        @contacts = {}
        @clients = {}
        @since = since || DEFAULT_DATE
        @result = { campaigns: 0, leads: 0 }
      end

      def call
        collect_campaigns
        collect_delivered_reports
        collect_leads
      end

      private

      def collect_campaigns
        maropost_accounts.each do |account|
          @client = client_for(account)
          each_campaigns_page do |collection|
            campaigns = collection.select { |c| c.status == 'sent' }
            campaigns.each { |campaign| find_or_create_campaign(campaign) }
          end
        end
      end

      def each_campaigns_page
        @page = 1
        while true do
          result = client.campaigns.all(page: @page)
          break if result.empty?
          @page += 1
          yield result
        end
      rescue MaropostApi::Errors => e
        puts "Maropost campaigns fetch failed due to error: #{e.to_s}"
      end

      def find_or_create_campaign(campaign)
        full_campaign = client.campaigns[campaign['id']]
        EmailMarketerCampaign.find_or_initialize_by(origin: 'Maropost', campaign_id: campaign['id']) do |c|
          c.subject = campaign['subject']
          c.sent_at = campaign['sent_at'] || campaign['send_at'] || campaign['created_at']
          c.list_ids = full_campaign['lists'].map(&:id)
        end.update(stats: {
          'sent' => full_campaign['sent'],
          'opens' => full_campaign['unique_opens'],
          'clicks' => full_campaign['unique_clicks']
        })
        @result[:campaigns] += 1
      end

      def collect_delivered_reports
        maropost_accounts.each do |account|
          @client = client_for(account)
          EmailMarketerCampaign.from_maropost.each do |campaign|
            each_delivered_reports_page(campaign.campaign_id) do |collection|
              emails = collection.map(&:email)
              (emails & user_emails).each do |email|
                Leads::Maropost.find_or_create_by(
                  lead_params(
                    users_by_email[email],
                    { 'campaign_id' => campaign.campaign_id },
                    'sent_message'
                  )
                ) do |lead|
                  lead.email = email
                  lead.event_at = campaign.sent_at
                end

                @result[:leads] += 1
              end
            end
          end
        end
      end

      def each_delivered_reports_page(campaign_id)
        @page = 1
        while true do
          result = client.campaigns.delivered_report(id: campaign_id, page: @page)
          break if result.empty?
          @page += 1
          yield result
        end
      rescue MaropostApi::Errors => e
        puts "Maropost delivered reports fetch failed due to error: #{e.to_s}"
        []
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

      def users_by_email
        @users_by_email ||= users.index_by(&:email)
      end

      def user_emails
        @user_emails ||= users.pluck(:email).uniq
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

      def maropost_accounts
        @maropost_accounts ||= MaropostAccount.all
      end
    end
  end
end
