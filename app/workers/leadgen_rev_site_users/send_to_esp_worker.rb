module LeadgenRevSiteUsers
  class SendToEspWorker
    include Sidekiq::Worker
    include Concerns::EspWorker

    def perform
      rules.each do |rule|
        leadgen_rev_site_users = available_leadgen_rev_site_users_for(rule)
        leadgen_rev_site_users = leadgen_rev_site_users.where('users.email ~* ?', '@' + rule.domain + '\.\w+$') if rule.domain.present?
        filtered_esp_lists = filter_esp_rules_lists(rule.esp_rules_lists)
        return if filtered_esp_lists.count.zero?
        leadgen_rev_site_users.each_slice(filtered_esp_lists.count) do |slice|
          slice.each_with_index do |leadgen_rev_site_user, index|
            next unless rule.should_send_now?(leadgen_rev_site_user.created_at)
            params = {
              affiliate: leadgen_rev_site_user.affiliate,
              ipAddress: leadgen_rev_site_user.ip,
              url: leadgen_rev_site_user.url,
              ip: leadgen_rev_site_user.ip,
              date: leadgen_rev_site_user.created_at,
              signup_method: 'Webform',
              state: leadgen_rev_site_user.state,
              user_agent: leadgen_rev_site_user.user_agent
            }.compact

            esp_list = filtered_esp_lists[index]
            next unless esp_list
            begin
              subscription_service_for(esp_list.list_type).new(esp_list.list, params: params, esp_rule: rule).send(:add, leadgen_rev_site_user.user)
            rescue => e
              puts "Error adding to #{esp_list.list.type}: #{e.to_s}"
            end
          end
        end
      end
    end

    private

    def rules
      EspRules::LeadgenRevSite.includes(source: :leadgen_rev_site_users).where.not(delay_in_hours: 0)
    end

    def available_leadgen_rev_site_users_for(rule)
      rule.leadgen_rev_site.leadgen_rev_site_users.is_verified
        .joins(:user)
        .where('leadgen_rev_site_users.created_at >= ?', rule.delay_in_hours.hours.ago.beginning_of_hour).distinct
    end
  end
end
