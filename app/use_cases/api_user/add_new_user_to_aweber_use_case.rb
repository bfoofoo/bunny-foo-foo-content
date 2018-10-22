class ApiUser
  class AddNewUserToAweberUseCase < AddNewUserToEspUseCase
    def perform
      super do |mapping|
        params = { affiliate: mapping.tag }.compact
        EmailMarketerService::Aweber::SubscriptionService.new(mapping.destination, params: params).add_subscriber(api_user)
      end
    end

    private

    def list_class
      'AweberList'
    end
  end
end
