module Concerns
  module EspWorker
    ESP_METHOD_MAPPING = {
      'AweberList' => :add_subscriber,
      'AdopiaList' => :add_contact,
      'EliteGroup' => :add_contact,
      'OngageList' => :add_contact,
      'NetatlanticList' => :add_subscriber,
      'MailgunList' => :add_member,
      'OnepointList' => :add_contact,
    }.freeze

    def subscription_service_for(list_type)
      ['EmailMarketerService', provider_for(list_type), 'SubscriptionService'].join('::').constantize
    end

    def provider_for(list_type)
      list_type.split(/(?=[A-Z])/).first
    end
  end
end
