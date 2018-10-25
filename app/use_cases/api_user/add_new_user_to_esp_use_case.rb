class ApiUser
  class AddNewUserToEspUseCase
    include Concerns::EspMappings

    attr_reader :api_user
    alias_attribute :user, :api_user

    def initialize(api_user)
      @api_user = api_user
    end

    def perform
      return false unless api_user.is_verified
      rules.each do |rule|
        next if rule.domain.present? && !(api_user.email =~ /@#{Regexp.quote(rule.domain)}\.\w+$/)
        params = { affiliate: rule.affiliate }.compact
        if rule.split?
          send_user_to_next_list(rule.esp_rules_lists.map(&:list), rule, params)
        else
          send_user(rule.esp_rules_lists.first.list, rule, params)
        end
      end
    end

    private

    def rules
      EspRules::ApiClient.where(source: api_user.api_client, delay_in_hours: 0)
    end
  end
end
