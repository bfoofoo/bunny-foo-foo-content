module Concerns
  module EspWorker
    extend ActiveSupport::Concern

    def subscription_service_for(list_type)
      ['EmailMarketerService', provider_for(list_type), 'SubscriptionService'].join('::').constantize
    end

    def provider_for(list_type)
      list_type.split(/(?=[A-Z])/).first
    end

    def filter_esp_rules_lists(erls)
      erls.select { |erl| erl.should_look_back? }
    end
  end
end
