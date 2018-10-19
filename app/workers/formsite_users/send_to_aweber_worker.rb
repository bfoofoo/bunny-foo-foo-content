module FormsiteUsers
  class SendToAweberWorker < SendToEspWorker
    def perform
      super do |params, mapping, formsite_user|
        EmailMarketerService::Aweber::SubscriptionsService
          .new(list: mapping.aweber_list, params: params)
          .add_subscriber(formsite_user.user)
      end
    end

    private

    def mapping_class
      FormsiteMappings::Aweber
    end

    def list_to_user_association
      :aweber_list_users
    end
  end
end
