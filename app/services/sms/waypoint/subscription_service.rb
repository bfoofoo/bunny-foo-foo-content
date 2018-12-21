module Sms
  module Waypoint
    class SubscriptionService
      attr_reader :params, :account

      def initialize(params: {}, account:nil)
        @account = account
        @params = params
      end

      def add(user)
        begin
          user_name = user.try(:full_name).blank? ? user.try(:name) : user.full_name
          new_params = params.merge({
            email: user.try(:email),
            address1: params[:ip],
            firstname: user&.first_name,
            lastname: user&.last_name,
            phone1: params[:phone]
          })
          client.create_contact(new_params)
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
