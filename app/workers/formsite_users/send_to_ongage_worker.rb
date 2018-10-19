module FormsiteUsers
  class SendToOngageWorker < SendToEspWorker
    def perform
      super do |params, mapping, formsite_user|
        EmailMarketerService::Ongage::SubscriptionsService
          .new(list: mapping.destination, params: params)
          .add_contact(formsite_user.user)
      end
    end

    private

    def mapping_class
      FormsiteMappings::Ongage
    end

    def list_to_user_association
      :ongage_list_users
    end
  end
end
