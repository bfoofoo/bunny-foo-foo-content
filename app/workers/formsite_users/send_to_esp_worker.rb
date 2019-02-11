module FormsiteUsers
  class SendToEspWorker
    include Sidekiq::Worker
    include Concerns::EspWorker

    def perform
      rules.each do |rule|
        formsite_users = available_formsite_users_for(rule)
        formsite_users = formsite_users.where('users.email ~* ?', '@' + rule.domain + '\.\w+$') if rule.domain.present?
        filtered_esp_lists = filter_esp_rules_lists(rule.esp_rules_lists)
        return if filtered_esp_lists.count.zero?
        formsite_users.each_slice(filtered_esp_lists.count) do |slice|
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
            esp_list = filtered_esp_lists[index]
            next unless esp_list
            begin
              subscription_service_for(esp_list.list_type).new(esp_list.list, params: params, esp_rule: rule).send(:add, formsite_user.user)
            rescue => e
              puts "Error adding to #{esp_list.list.type}: #{e.to_s}"
            end
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
