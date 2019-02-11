class LeadgenRevSite
  class AddNewUserToEspUseCase
    include Concerns::EspMappings

    attr_reader :leadgen_rev_site, :user, :leadgen_rev_site_user

    def initialize(leadgen_rev_site, user, leadgen_rev_site_user)
      @user = user
      @leadgen_rev_site = leadgen_rev_site
      @leadgen_rev_site_user = leadgen_rev_site_user
      @params = {
        affiliate: leadgen_rev_site_user.affiliate,
        ipAddress: leadgen_rev_site_user.ip,
        url: leadgen_rev_site_user.url,
        ip: leadgen_rev_site_user.ip,
        date: leadgen_rev_site_user.created_at,
        signup_method: 'Webform',
        state: leadgen_rev_site_user.state,
        phone: leadgen_rev_site_user.phone,
        user_agent: leadgen_rev_site_user.user_agent
      }.compact
    end

    def perform
      return false if !leadgen_rev_site_user.is_verified || user.blank?
      schedule_for_colossus
      rules.each do |rule|
        next if rule.domain.present? && !(leadgen_rev_site_user.email =~ /@#{Regexp.quote(rule.domain)}\.\w+$/)
        if rule.split?
          send_user_to_next_list(rule.esp_rules_lists.map(&:list), rule, @params)
        else
          send_user(rule.esp_rules_lists.first.list, rule, @params)
        end
      end
    end

    private

    def rules
      EspRules::LeadgenRevSite.where(source: leadgen_rev_site, delay_in_hours: 0)
    end

    def schedule_for_colossus
      LeadgenRevSiteUsers::SendToColossusWorker.perform_async(leadgen_rev_site_user.id, user.id)
    end
  end
end
