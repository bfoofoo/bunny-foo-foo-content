module ApiUsers
  class SendToOngageWorker < SendToEspWorker
    def perform
      super do |params, mapping, api_user|
        EmailMarketerService::Ongage::SubscriptionsService
          .new(list: mapping.destination, params: params)
          .add_contact(api_user)
      end
    end

    private

    def api_users
      super.with_ongage_mappings
    end

    def list_method
      :api_client_ongage_lists
    end
  end
end
