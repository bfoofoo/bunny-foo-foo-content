module Concerns
  module EspMappings
    extend ActiveSupport::Concern

    def subscription_service_for(list_type)
      ['EmailMarketerService', provider_for(list_type), 'SubscriptionService'].join('::').constantize
    end

    def provider_for(list_type)
      list_type.split(/(?=[A-Z])/).first
    end

    def send_user(list, rule, params)
      return if user.sent_to_list?(list)
      if list.sending_limit&.reached? || list.sending_limit&.isp_limit_reached?(user.email)
        send_over_limit(rule, params)
        return
      end
      subscription_service_for(list.model_name.name).new(list, params: params, esp_rule: rule).send(:add, user)
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
