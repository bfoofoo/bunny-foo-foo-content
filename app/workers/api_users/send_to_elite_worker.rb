module ApiUsers
  class SendToEliteWorker < SendToEspWorker
    def perform
      super do |params, mapping, api_user|
        EmailMarketerService::Elite::SubscriptionsService
          .new(group: mapping.destination, params: params)
          .add_contact(api_user)
      end
    end

    private

    def api_users
      super.with_elite_mappings
    end

    def list_method
      :api_client_elite_groups
    end
  end
end
