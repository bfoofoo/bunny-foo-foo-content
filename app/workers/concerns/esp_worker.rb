module Concerns
  module EspWorker
    extend ActiveSupport::Concern

    ESP_METHOD_MAPPING = {
      'AdopiaList' => :add_contact,
      'EliteGroup' => :add_contact,
      'NetatlanticList' => :add_subscriber,
      'MailgunList' => :add_member,
      'OnepointList' => :add_contact,
      'SparkpostList' => :add_recipient,
      'GetresponseList' => :add_contact
    }.freeze

    def subscription_service_for(list_type)
      ['EmailMarketerService', provider_for(list_type), 'SubscriptionService'].join('::').constantize
    end

    def provider_for(list_type)
      list_type.split(/(?=[A-Z])/).first
    end
  end
end
