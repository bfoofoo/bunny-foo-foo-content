module EspRules
  class ApiClient < EspRule
    default_scope { where(source_type: 'ApiClient') }

    alias_attribute :api_client, :source

    validates :affiliate, presence: true
  end
end
