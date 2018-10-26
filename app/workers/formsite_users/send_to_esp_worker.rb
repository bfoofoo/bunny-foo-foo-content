module FormsiteUsers
  class SendToEspWorker
    include Sidekiq::Worker

    ESP_METHOD_MAPPING = {
      'AweberList' => :add_subscriber,
      'AdopiaList' => :add_contact,
      'EliteGroup' => :add_contact,
      'OngageList' => :add_contact
    }.freeze

    def perform
      rules.each do |rule|
        formsite_users = available_formsite_users_for(rule)
        formsite_users = formsite_users.where('users.email ~* ?', '@' + rule.domain + '\.\w+$') if rule.domain.present?
        formsite_users.each_slice(rule.esp_rules_lists.count) do |slice|
          slice.each_with_index do |formsite_user, index|
            next unless rule.should_send_now?(formsite_user.created_at)
            params = { affiliate: formsite_user.affiliate }.compact
            esp_list = rule.esp_rules_lists[index]
            subscription_service_for(esp_list.list_type).new(esp_list.list, params: params).send(ESP_METHOD_MAPPING[esp_list.list_type], formsite_user.user)
          end
        end
      end
    end

    private

    def rules
      EspRules::Formsite.includes(source: :formsite_users).where.not(delay_in_hours: 0)
    end

    def available_formsite_users_for(rule)
      rule.formsite.formsite_users.is_verified.left_joins(user: :exported_leads).where('exported_leads.esp_rule_id <> ? OR exported_leads.id IS NULL', rule.id).distinct
    end

    def subscription_service_for(list_type)
      ['EmailMarketerService', provider_for(list_type), 'SubscriptionService'].join('::').constantize
    end

    def provider_for(list_type)
      list_type.split(/(?=[A-Z])/).first
    end
  end
end
