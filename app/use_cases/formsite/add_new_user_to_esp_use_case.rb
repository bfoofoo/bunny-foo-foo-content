class Formsite
  class AddNewUserToEspUseCase
    include UseCases::EspMappings

    attr_reader :formsite, :user, :formsite_user

    def initialize(formsite, user, formsite_user)
      @user = user
      @formsite = formsite
      @formsite_user = formsite_user
      @params = { affiliate: formsite_user.affiliate }.compact
    end

    def perform
      return false if !formsite_user.is_verified || user.blank?
      rules.each do |rule|
        next if rule.domain && !formsite_user.email =~ /@#{Regexp.quote(rule.domain)}\.\w+$/
        send_user(rule.esp_rules_lists.first, rule, @params) unless rule.split?
        rule.esp_rules_lists.each do |list|
          send_user(list, rule, @params)
        end
      end
    end

    private

    def rules
      EspRules::Formsite.where(source: formsite, delay_in_hours: 0)
    end
  end
end
