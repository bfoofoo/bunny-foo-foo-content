class EspRulesList < ApplicationRecord
  belongs_to :esp_rule
  belongs_to :list, polymorphic: true

  delegate :full_name, to: :list

  scope :above_limit, -> { where(is_over_limit: true) }
  scope :below_limit, -> { where(is_over_limit: false) }
end
