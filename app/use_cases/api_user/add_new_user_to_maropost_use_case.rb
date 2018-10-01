class ApiUser
  class AddNewUserToMaropostUseCase < AddNewUserToEspUseCase
    def perform
      super do |mapping|
        params = { affiliate: mapping.tag }.compact
        EmailMarketerService::Maropost::AddContactsToList.new(list: mapping.destination, params: params).add(api_user)
      end
    end

    private

    def list_class
      'MaropostList'
    end
  end
end
