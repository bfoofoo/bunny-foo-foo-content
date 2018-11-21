class Website
  class AddNewUserToEspUseCase
    include Concerns::EspMappings

    attr_reader :website, :user, :formsite_user

    def initialize(website, user, formsite_user)
      @user = user
      @website = website
      @formsite_user = formsite_user
      @params = {affiliate: formsite_user.affiliate}.compact
    end

    def perform
      return false if !formsite_user.is_verified || user.blank?
      rules.each do |rule|
        next if rule.esp_rules_lists.blank?
        next if rule.domain.present? && !(formsite_user.email =~ /@#{Regexp.quote(rule.domain)}\.\w+$/)
        if rule.split?
          send_user_to_next_list(rule.esp_rules_lists.map(&:list), rule, @params)
        else
          send_user(rule.esp_rules_lists.first.list, rule, @params)
        end
      end
    end

    private

    def rules
      EspRules::Website.where(source: website, delay_in_hours: 0)
    end
  end
end
