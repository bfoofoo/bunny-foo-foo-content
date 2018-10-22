class ApiUser
  class AddNewUserToOngageUseCase < AddNewUserToEspUseCase
    def perform
      super do |mapping|
        params = { affiliate: mapping.tag }.compact
        EmailMarketerService::Ongage::SubscriptionService.new(mapping.destination, params: params).add_contact(api_user)
      end
    end

    private

    def list_class
      'OngageList'
    end
  end
end
