class ApiUser
  class AddNewUserToEspUseCase
    include UseCases::EspMappings

    attr_reader :api_user

    def initialize(api_user)
      @api_user = api_user
    end

    def perform
      return false unless api_user.is_verified
      rules.each do |rule|
        next if rule.domain && !api_user.email =~ /@#{Regexp.quote(rule.domain)}\.\w+$/
        params = { affiliate: rule.affiliate }.compact
        send_user(rule.esp_rules_lists.first, rule, params) unless rule.split?
        rule.esp_rules_lists.each do |list|
          send_user(list, rule, params)
        end
      end
    end

    private

    def rules
      EspRules::ApiClient
        .where(source: api_user.api_client, delay_in_hours: 0)
    end
  end
end
