class EspRulesList < ApplicationRecord
  LOOKBACK_ENABLED_LIST_TYPES = %w(WaypointList).freeze

  belongs_to :esp_rule
  belongs_to :list, polymorphic: true

  delegate :full_name, to: :list

  scope :above_limit, -> { where(is_over_limit: true) }
  scope :below_limit, -> { where(is_over_limit: false) }

  def should_look_back?
    return true if list&.type&.in?(LOOKBACK_ENABLED_LIST_TYPES)
    esp_rule.delay_passed?
  end
end
