class Formsite
  class AddNewUserToOngageUseCase < AddNewUserToEspUseCase
    def perform
      super do |mapping, user, params|
        EmailMarketerService::Ongage::SubscriptionService.new(mapping.ongage_list, params: params).add_contact(user)
      end
    end

    def mapping_association
      :formsite_ongage_lists
    end
  end
end
