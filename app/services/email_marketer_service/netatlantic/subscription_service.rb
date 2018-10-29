module EmailMarketerService
  module Netatlantic
    class SubscriptionService < EmailMarketerService::Netatlantic::BaseService
      attr_reader :list, :params

      def initialize(list, params: nil, esp_rule: nil)
        @list = list
        @params = params
        @esp_rule = esp_rule
      end

      def add_subscriber(user)
        user_name = user.try(:full_name).blank? ? user.try(:name) : user.full_name
        HTTParty.post("#{API_PATH}/create_member.php", body: {email: user.email, full_name: user_name})
      end
    end
  end
end
