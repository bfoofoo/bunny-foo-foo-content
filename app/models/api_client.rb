class ApiClient < ApplicationRecord
  has_many :api_users
  has_many :esp_rules, as: :source, class_name: 'EspRules::ApiClient'

  accepts_nested_attributes_for :esp_rules, allow_destroy: true
end
