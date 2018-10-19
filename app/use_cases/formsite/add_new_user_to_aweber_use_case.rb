class Formsite
  class AddNewUserToAweberUseCase < AddNewUserToEspUseCase
    def perform
      super do |mapping, user, params|
        EmailMarketerService::Aweber::SubscriptionsService.new(list: mapping.aweber_list, params: params).add_subscriber(user)
      end
    end

    def mapping_association
      :formsite_aweber_lists
    end
  end
end
