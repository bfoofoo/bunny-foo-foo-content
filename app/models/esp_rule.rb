class EspRule < ApplicationRecord
  belongs_to :source
  has_many :esp_rules_lists

  accepts_nested_attributes_for :esp_rules_lists, allow_destroy: true

  validates :delay_in_hours, numericality: { greater_than_or_equal_to: 0 }
  validates :esp_rules_lists, presence: true
end
