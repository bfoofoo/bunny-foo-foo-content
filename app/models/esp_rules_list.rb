class EspRulesList < ApplicationRecord
  belongs_to :esp_rule, polymorphic: true
  belongs_to :list, polymorphic: true
end
