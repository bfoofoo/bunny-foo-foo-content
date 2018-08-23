module EmailMarketerService
  module Aweber
    class FetchOpeners
      attr_reader :list, :since

      OPENERS_TAG = 'openers' # as set in Aweber Broadcast automations

      def initialize(list: nil, since: nil)
        @list = list
        @since = since.is_a?(Date) ? since : Date.parse(since) rescue nil
        @current_index = 0
      end

      def call
        # Aweber API 1.0 allows to fetch only up to 100 subscribers per request, so let's process 'em in batches
        while @current_index < total_subscribers_count do
          subscribers = subscribers_for_list.search(search_params)&.entries&.values.to_a
          yield subscribers if block_given?
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

      def total_subscribers_count
        @total_subscribers_count ||= subscribers_for_list.search('tags' => [OPENERS_TAG], 'ws.show' => 'total_size')
      end
    end
  end
end
