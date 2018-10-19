module ApiUsers
  class SendToAweberWorker < SendToEspWorker
    def perform
      super do |params, mapping, api_user|
        EmailMarketerService::Aweber::SubscriptionsService
          .new(list: mapping.destination, params: params)
          .add_subscriber(api_user)
      end
    end

    private

    def mapping_class
      FormsiteMappings::Aweber
    end

    def list_to_user_association
      :api_client_aweber_lists
    end
  end
end
