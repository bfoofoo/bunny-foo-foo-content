module EmailMarketerService
  module Aweber
    class SubscriptionsService
      attr_reader :list
      
      def initialize(list:nil)
        @list = list
      end

      def add_subscriber(user)
        begin
          aweber_list.subscribers.create({"name" => user.full_name, "email" => user.email})
        rescue AWeber::CreationError => e
          puts e
        end
      end

      private
      def auth_service
        return @auth_service if !@auth_service.blank?
        @auth_service = EmailMarketerService::Aweber::AuthService.new(
          access_token: account.access_token,
          secret_token: account.secret_token,
        )
      end

      def aweber_list
        @aweber_list ||= auth_service.aweber.account.lists[list.list_id]
      end

      def account
        @account ||= list.aweber_account
      end

    end
  end
end