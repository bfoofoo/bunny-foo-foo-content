class Formsite
  class AddNewUserToOngageUseCase < AddNewUserToEspUseCase
    def perform
      return false if !formsite_user.is_verified || user.blank?
      params = { affiliate: formsite_user.affiliate }
      lists.each do |list|
        EmailMarketerService::Ongage::SubscriptionsService.new(list: list.ongage_list, params: params).add_contact(user)
      end
    end

    def list_class
      :formsite_ongage_lists
    end
  end
end
