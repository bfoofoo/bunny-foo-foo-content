class Formsite
  class AddNewUserToEliteUseCase < AddNewUserToEspUseCase
    def perform
      return false if !formsite_user.is_verified || user.blank?
      params = { affiliate: formsite_user.affiliate }.compact
      lists.each do |list|
        EmailMarketerService::Elite::SubscriptionsService.new(group: list.elite_group, params: params).add_contact(user)
      end
    end

    def list_class
      :formsite_elite_groups
    end
  end
end
