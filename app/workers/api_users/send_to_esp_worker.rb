module ApiUsers
  class SendToEspWorker
    include Sidekiq::Worker

    ESP_METHOD_MAPPING = {
      'AweberList' => :add_subscriber,
      'AdopiaList' => :add_contact,
      'EliteGroup' => :add_contact,
      'OngageList' => :add_contact,
      'NetatlanticList' => :add_subscriber,
      'MailgunList' => :add_member
    }.freeze

    def perform
      rules.each do |rule|
        params = { affiliate: rule.affiliate }.compact
        api_users = available_api_users_for(rule)
        api_users = api_users.by_email_domain(rule.domain) if rule.domain.present?
        api_users.each_slice(rule.esp_rules_lists.count) do |slice|
          slice.each_with_index do |api_user, index|
            next unless rule.should_send_now?(api_user.created_at)
            esp_list = rule.esp_rules_lists[index]
            subscription_service_for(esp_list.list_type).new(esp_list.list, params: params).send(ESP_METHOD_MAPPING[esp_list.list_type], api_user)
          end
        end
      end
    end

    private

    def rules
      EspRules::ApiClient.includes(source: :api_users).where.not(delay_in_hours: 0)
    end

    def available_api_users_for(rule)
      rule.api_client.api_users.verified.left_joins(:exported_leads).where('exported_leads.esp_rule_id <> ? OR exported_leads.id IS NULL', rule.id).distinct
    end

    def subscription_service_for(list_type)
      ['EmailMarketerService', provider_for(list_type), 'SubscriptionService'].join('::').constantize
    end

    def provider_for(list_type)
      list_type.split(/(?=[A-Z])/).first
    end
  end
end
