module EmailMarketerService
  module Maropost
    class FindLeads
      attr_reader :client

      EVENT_TYPES = %w(open click).freeze

      def initialize(since: nil)
        @auth_services = {}
        @subscribers = {}
        @accounts = {}
        @contacts = {}
        @clients = {}
        @since = since ? since : last_lead_date
      end

      def call
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

      private

      def events_by_type(event_type, user)
        method = event_type.pluralize
        client
          .reports
          .send(method, maropost_report_params.merge('email' => user.email))
          .uniq { |o| o['campaign_id'] }
      rescue MaropostApi::Errors => e
        puts "Maropost reports fetch failed due to error: #{e.to_s}"
        []
      end

      def event_campaign_sent_at(event)
        campaign = client.campaigns[event['campaign_id']]
        campaign['sent_at']
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
            .where.not(formsite_users: { affiliate: nil })
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
        affiliate = user.formsite_users.first.affiliate || contact_by_email(user.email)&.[]('affiliate')
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
          'from' => @since&.to_date&.to_s
        }.compact
      end

      def last_lead_date
        Leads::Maropost.maximum(:event_at)&.to_date
      end
    end
  end
end
