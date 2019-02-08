module LeadgenRevSiteUsers
  class SendToEspWorker
    include Sidekiq::Worker
    include Concerns::EspWorker

    def perform
      rules.each do |rule|
        leadgen_rev_site_users = available_leadgen_rev_site_users_for(rule)
        return if leadgen_rev_site_users.blank? || rule.esp_rules_lists.below_limit.count.zero?
        leadgen_rev_site_users = leadgen_rev_site_users.where('users.email ~* ?', '@' + rule.domain + '\.\w+$') if rule.domain.present?
        leadgen_rev_site_users.each_slice(rule.esp_rules_lists.below_limit.count) do |slice|
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
            esp_list = rule.esp_rules_lists[index]
            esp_list = rule.esp_rules_lists.above_limit.sample if esp_list.list.sending_limit&.reached? || esp_list.list.sending_limit&.isp_limit_reached?(leadgen_rev_site_user.user.email)
            next unless esp_list
            subscription_service_for(esp_list.list_type).new(esp_list.list, params: params, esp_rule: rule).send(:add, leadgen_rev_site_user.user)
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
