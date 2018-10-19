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

    def mapping_class
      FormsiteMappings::Elite
    end

    def list_to_user_association
      :api_client_elite_groups
    end
  end
end
