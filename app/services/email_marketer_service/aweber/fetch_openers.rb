module EmailMarketerService
  module Aweber
    class FetchOpeners
      attr_reader :list, :since

      OPENERS_TAG = 'openers' # as set in Aweber Broadcast automations
      GROUP_SIZE = 100 # as set by Aweber API 1.0

      def initialize(list: nil, since: nil)
        @list = list
        @since = since.is_a?(Date) ? since : Date.parse(since) rescue nil
        @current_index = 0
        @date = @since || Date.current
        @total_subscribers_counts = {}
      end

      def call
        end_date = Date.current
        # Aweber API 1.0 allows to fetch only up to 100 subscribers per request, so let's process 'em in batches
        while @date <= end_date
          while @current_index < total_subscribers_count do
            begin
              retries = 0
              subscribers = subscribers_for_list.search(search_params)&.entries&.values.to_a
            rescue AWeber::UnknownRequestError => e
              Rails.logger.error("[#{Time.current.to_s}] #{e.to_s}")
              @current_index += GROUP_SIZE
              retries += 1
              retry if e.to_s == 'Invalid/used nonce' && retries < 2
            rescue AWeber::ServiceUnavailableError => e
              retries += 1
              retry if retries < 2
            else
              yield subscribers if block_given?
              @current_index += subscribers.size
            ensure
              sleep 0.6 # to bypass AWeber Rate Limit
            end
          end
          @current_index = 0
          @date += 1.day
        end
      # Also catch from total_subscriber_count method
      rescue AWeber::UnknownRequestError => e
        Rails.logger.error(e.to_s)
        return []
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
          'ws.start' => @current_index,
          'subscribed_at' => @date
        }
      end

      def total_subscribers_count
        @total_subscribers_counts[@date.to_s] ||=
          subscribers_for_list.search('tags' => [OPENERS_TAG], 'ws.show' => 'total_size', 'subscribed_at' => @date.to_s)
      end
    end
  end
end
