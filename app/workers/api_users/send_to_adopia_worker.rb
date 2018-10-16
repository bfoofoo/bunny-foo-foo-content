module ApiUsers
  class SendToAdopiaWorker < SendToEspWorker
    def perform
      super do |params, mapping, api_user|
        EmailMarketerService::Adopia::SubscriptionsService
          .new(list: mapping.destination, params: params)
          .add_contact(api_user)
      end
    end

    private

    def api_users
      super.with_adopia_mappings
    end

    def list_method
      :api_client_adopia_lists
    end
  end
end
