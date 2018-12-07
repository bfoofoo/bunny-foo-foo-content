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
        next if rule.esp_rules_lists.blank?
        next if rule.domain.present? && !(api_user.email =~ /@#{Regexp.quote(rule.domain)}\.\w+$/)
        if rule.split?
          send_user_to_next_list(rule.esp_rules_lists.below_limit.map(&:list), rule, params(rule))
        else
          send_user(rule.esp_rules_lists.below_limit.first.list, rule, params(rule))
        end
      end
    end

    private

    def params(rule)
      {
        ip: api_user.ip,
        date: api_user.created_at,
        signup_method: 'Webform',
        affiliate: rule.affiliate
      }.compact
    end

    def rules
      EspRules::ApiClient.where(source: api_user.api_client, delay_in_hours: 0)
    end
  end
end
