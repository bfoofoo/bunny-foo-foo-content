module FormsiteUsers
  class SendToEliteWorker < SendToEspWorker
    def perform
      super do |params, mapping, formsite_user|
        EmailMarketerService::Elite::SubscriptionsService
          .new(group: mapping.destination, params: params)
          .add_contact(formsite_user.user)
      end
    end

    private

    def mapping_class
      FormsiteMappings::Elite
    end

    def list_to_user_association
      :elite_group_users
    end
  end
end
