class EspRulesList < ApplicationRecord
  belongs_to :esp_rule, polymorphic: true
  belongs_to :list, polymorphic: true

  #validates :list_id, uniqueness: { scope: [:list_type, :esp_rule_id] }
  #

  delegate :full_name, to: :list
end
