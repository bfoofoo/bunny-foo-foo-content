module FormsiteUsers
  class SendToEspWorker
    include Sidekiq::Worker
    include Concerns::EspWorker

    def perform
      rules.each do |rule|
        formsite_users = available_formsite_users_for(rule)
        formsite_users = formsite_users.where('users.email ~* ?', '@' + rule.domain + '\.\w+$') if rule.domain.present?
        formsite_users.each_slice(rule.esp_rules_lists.below_limit.count) do |slice|
          slice.each_with_index do |formsite_user, index|
            next unless rule.should_send_now?(formsite_user.created_at)
            params = {
              affiliate: formsite_user.affiliate,
              ipAddress: formsite_user.ip,
              url: formsite_user.url,
              ip: formsite_user.ip,
              date: formsite_user.created_at,
              signup_method: 'Webform',
              state: formsite_user.state
            }.compact
            esp_list = rule.esp_rules_lists[index]
            esp_list = rule.esp_rules_lists.above_limit.sample if esp_list.list.sending_limit&.reached? || esp_list.list.sending_limit&.isp_limit_reached?(formsite_user.user.email)
            next unless esp_list
            subscription_service_for(esp_list.list_type).new(esp_list.list, params: params, esp_rule: rule).send(:add, formsite_user.user)
          end
        end
      end
    end

    private

    def rules
      EspRules::Formsite.includes(source: :formsite_users).where.not(delay_in_hours: 0)
    end

    def available_formsite_users_for(rule)
      rule.formsite.formsite_users.is_verified.joins(:user).where('formsite_users.created_at >= ?', rule.delay_in_hours.hours.ago.beginning_of_hour).distinct
    end
  end
end
