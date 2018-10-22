module UseCases
  module EspMappings
    extend ActiveSupport::Concern

    ESP_METHOD_MAPPING = {
      'AweberList' => :add_subscriber,
      'AdopiaList' => :add_contact,
      'EliteGroup' => :add_contact,
      'OngageList' => :add_contact
    }.freeze


    def subscription_service_for(list_type)
      ['EmailMarketerService', provider_for(list_type), 'SubscriptionService'].join('::').constantize
    end

    def provider_for(list_type)
      list_type.split(/(?=[A-Z])/).first
    end

    def send_user(list, rule, params)
      subscription_service_for(list.list_type).new(list, params, rule).send(ESP_METHOD_MAPPING[list.list_type], user)
    end
  end
end
