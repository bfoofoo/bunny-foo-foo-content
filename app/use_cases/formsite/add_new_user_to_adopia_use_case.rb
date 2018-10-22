class Formsite
  class AddNewUserToAdopiaUseCase < AddNewUserToEspUseCase
    def perform
      super do |mapping, user, params|
        EmailMarketerService::Adopia::SubscriptionService.new(mapping.adopia_list, params: params).add_contact(user)
      end
    end

    def mapping_association
      :formsite_adopia_lists
    end
  end
end
