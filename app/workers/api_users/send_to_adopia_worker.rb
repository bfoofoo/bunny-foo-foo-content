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

    def mapping_class
      FormsiteMappings::Adopia
    end

    def list_to_user_association
      :api_client_adopia_lists
    end
  end
end
