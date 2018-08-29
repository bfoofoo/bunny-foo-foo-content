module EmailMarketerService
  module Aweber
    class SubscriptionsService
      attr_reader :list, :params

      def initialize(list: nil, params: nil)
        @list = list
        @params = params
      end

      def add_subscriber(user)
        begin
          user_name = user.try(:full_name).blank? ? user.name : user.full_name
          if is_valid?(user)
            aweber_list.subscribers.create({ "name" => user_name, "email" => user.email, "custom_fields" => { 'Affiliate' => params[:affiliate] } })
          end
        rescue AWeber::CreationError => e
          handle_user_record(user) if e.message == "email: Subscriber already subscribed."
          puts "Aweber adding subscriber error - #{e}".red
        end
      end

      def subscribers(search_params={})
        aweber_list.subscribers.search(search_params)
      end

      private

      def handle_user_record user
        user.update(added_to_aweber: true) if user.is_a?(ActiveRecord::Base)
      end

      def is_valid?(user)
        if user.is_a?(ActiveRecord::Base)
          !user.added_to_aweber
        else
          true
        end
      end

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
