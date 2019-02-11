module ApiUsers
  class SendToEspWorker
    include Sidekiq::Worker
    include Concerns::EspWorker

    def perform
      rules.each do |rule|
        api_users = available_api_users_for(rule)
        api_users = api_users.by_email_domain(rule.domain) if rule.domain.present?
        filtered_esp_lists = filter_esp_rules_lists(rule.esp_rules_lists)
        return if filtered_esp_lists.count.zero?
        api_users.each_slice(filtered_esp_lists.count) do |slice|
          slice.each_with_index do |api_user, index|
            params = {
              affiliate: rule.affiliate,
              ipAddress: api_user.ip,
              ip: api_user.ip,
              date: api_user.created_at,
              signup_method: 'Webform',
              state: api_user.state
            }.compact
            next unless rule.should_send_now?(api_user.created_at)
            esp_list = filtered_esp_lists[index]
            next unless esp_list
            subscription_service_for(esp_list.list_type).new(esp_list.list, params: params, esp_rule: rule).send(:add, api_user)
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
