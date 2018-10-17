class Formsite
  class AddNewUserToAdopiaUseCase < AddNewUserToEspUseCase
    def perform
      return false if !formsite_user.is_verified || user.blank?
      params = { affiliate: formsite_user.affiliate }
      lists.each do |list|
        EmailMarketerService::Adopia::SubscriptionsService.new(list: list.adopia_list, params: params).add_contact(user)
      end
    end

    def list_class
      :formsite_adopia_lists
    end
  end
end
