module EmailMarketerService
  module Aweber
    class FetchOpeners
      attr_reader :list, :since

      def initialize(list: nil, since: nil)
        @list = list
        @since = since.is_a?(Date) ? since : Date.parse(since) rescue nil
        @current_index = 0
        @date = @since || Date.current
        @total_subscribers_counts = {}
      end

      def call
        subscribers_for_list.each_page do |page|
          openers = []
          subscribers = page&.entries&.values.to_a
          subscribers.each do |subscriber|
            subscriber.activity.each_page do |activity|
              values = activity&.entries&.values.to_a
              finds = values.select { |a| a.event_time.to_date >= @date && a.type == 'open' }
              openers << subscriber if finds.present?
              break if finds.present? || (values.present? && values.last.event_time.to_date < @date)
            end
            sleep 0.6 # to escape AWeber Rate Limit
          end
          yield openers if block_given?
          sleep 0.6 # to escape AWeber Rate Limit
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
    end
  end
end
