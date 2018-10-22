class ApiUser
  class AddNewUserToAdopiaUseCase < AddNewUserToEspUseCase
    def perform
      super do |mapping|
        params = { affiliate: mapping.tag }.compact
        EmailMarketerService::Adopia::SubscriptionService.new(mapping.destination, params: params).add_contact(api_user)
      end
    end

    private

    def list_class
      'AdopiaList'
    end
  end
end
