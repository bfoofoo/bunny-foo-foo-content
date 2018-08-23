module EmailMarketerService
  module Aweber
    class FetchOpenersLeads

      attr_reader :list, :since

      OPENERS_TAG = 'openers' # as set in Aweber Broadcast automations

      def initialize(list: nil, since: nil)
        @list = list
        @since = Date.parse(since) rescue nil
        @current_index = 0
      end

      def call
        # Aweber API 1.0 allows to fetch only up to 100 subscribers per request, so let's process 'em in batches
        while @current_index < total_subscribers_count do
          subscribers = subscribers_for_list.search(search_params)&.entries&.values.to_a
          create_leads(build_lead_list(subscribers)) unless subscribers.empty?
          @current_index += subscribers.size
        end
      end

      private

      def account
        @account ||= list.aweber_account
      end

      def aweber_list
        @aweber_list ||= auth_service.aweber.account.lists[list.list_id]
      end

      def auth_service
        return @auth_service if defined?(@auth_service)
        @auth_service = AuthService.new(
          access_token: account.access_token,
          secret_token: account.secret_token,
          )
      end

      def subscribers_for_list
        aweber_list.subscribers
      end

      def search_params
        {
          'tags' => [OPENERS_TAG],
          'ws.start' => @current_index
        }
      end

      def build_lead_list(subscribers)
        subscribers.each_with_object([]) do |subscriber, memo|
          next if should_skip_subscriber?(subscriber)
          memo << {
            email: subscriber.email,
            full_name: subscriber.name,
            details: {
              subscribed_at: subscriber.subscribed_at
            }
          }
        end
      end

      def should_skip_subscriber?(subscriber)
        existing_lead_emails.include?(subscriber.email) || (since.present? && Date.parse(subscriber.subscribed_at) < since)
      end

      def create_leads(leads)
        Leads::AweberToMaropost.import(leads)
      rescue => e
        puts "Error during import: #{e.to_s}"
      end

      def total_subscribers_count
        @total_subscribers_count ||= subscribers_for_list.search('tags' => [OPENERS_TAG], 'ws.show' => 'total_size')
      end

      def existing_lead_emails
        @existing_lead_emails ||= Leads::AweberToMaropost.pluck(:email)
      end
    end
  end
end
