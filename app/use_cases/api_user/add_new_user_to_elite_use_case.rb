class ApiUser
  class AddNewUserToEliteUseCase < AddNewUserToEspUseCase
    def perform
      super do |mapping|
        params = { affiliate: mapping.tag }.compact
        EmailMarketerService::Elite::SubscriptionService
          .new(group: mapping.destination, params: params)
          .add_contact(api_user)
      end
    end

    private

    def list_class
      'EliteGroup'
    end
  end
end
