module ApiUsers
  class SendToEspWorker
    include Sidekiq::Worker
    include Concerns::EspWorker

    def perform
      rules.each do |rule|
        params = { affiliate: rule.affiliate }.compact
        api_users = available_api_users_for(rule)
        api_users = api_users.by_email_domain(rule.domain) if rule.domain.present?
        api_users.each_slice(rule.esp_rules_lists.below_limit.count) do |slice|
          slice.each_with_index do |api_user, index|
            next unless rule.should_send_now?(api_user.created_at)
            esp_list = rule.esp_rules_lists[index]
            esp_list = rule.esp_rules_lists.above_limit.sample if esp_list.sending_limit&.reached? || esp_list.sending_limit&.isp_limit_reached?(api_user.email)
            next unless esp_list
            subscription_service_for(esp_list.list_type).new(esp_list.list, params: params, esp_rule: rule).send(ESP_METHOD_MAPPING[esp_list.list_type], api_user)
          end
        end
      end
    end

    private

    def rules
      EspRules::ApiClient.includes(source: :api_users).where.not(delay_in_hours: 0)
    end

    def available_api_users_for(rule)
      rule.api_client.api_users.verified.where('api_users.created_at >= ?', rule.delay_in_hours.hours.ago.beginning_of_hour).distinct
    end
  end
end
