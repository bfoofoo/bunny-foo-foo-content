module FormsiteUsers
  class SendToAdopiaWorker < SendToEspWorker
    def perform
      super do |params, mapping, formsite_user|
        EmailMarketerService::Adopia::SubscriptionsService
          .new(list: mapping.destination, params: params)
          .add_contact(formsite_user.user)
      end
    end

    private

    def mapping_class
      FormsiteMappings::Adopia
    end

    def list_to_user_association
      :adopia_list_users
    end
  end
end
