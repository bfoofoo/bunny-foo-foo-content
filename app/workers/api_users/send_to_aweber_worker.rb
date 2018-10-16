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

    def api_users
      super.with_aweber_mappings
    end

    def list_method
      :api_client_aweber_lists
    end
  end
end
