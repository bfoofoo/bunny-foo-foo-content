module Sms
  module Waypoint
    module SubscriptionService
      attr_reader :params

      def initialize(params: nil)
        @params = params
      end

      def add(user)
        begin
          user_name = user.try(:full_name).blank? ? user.try(:name) : user.full_name
          client.create_contact() @params
        rescue => e
          puts "Waypoint adding subscriber error - #{e}".red
        end
      end

      private

        def client
          return @client if defined?(@client)
          @client = Sms::Waypoint::ApiWrapperService.new(account: account, params: params)
        end

    end
  end
end
