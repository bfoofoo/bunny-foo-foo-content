module Concerns
  module EspMappings
    extend ActiveSupport::Concern

    ESP_METHOD_MAPPING = {
      'AweberList' => :add_subscriber,
      'AdopiaList' => :add_contact,
      'EliteGroup' => :add_contact,
      'OngageList' => :add_contact,
      'NetatlanticList' => :add_subscriber,
      'MailgunList' => :add_member
    }.freeze


    def subscription_service_for(list_type)
      ['EmailMarketerService', provider_for(list_type), 'SubscriptionService'].join('::').constantize
    end

    def provider_for(list_type)
      list_type.split(/(?=[A-Z])/).first
    end

    def send_user(list, rule, params)
      return if user.sent_to_list?(list)
      subscription_service_for(list.model_name.name).new(list, params: params, esp_rule: rule).send(ESP_METHOD_MAPPING[list.model_name.name], user)
    end

    def send_user_to_next_list(lists, rule, params)
      last_list = ExportedLead.where(esp_rule: rule)&.last&.list
      if !last_list || last_list == lists.last
        next_list = lists.first
      else
        index = lists.find_index { |l| l == last_list }
        next_list = lists[index + 1]
      end
      send_user(next_list, rule, params)
    end
  end
end
