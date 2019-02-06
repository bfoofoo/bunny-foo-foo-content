class EspRule < ApplicationRecord
  belongs_to :source, polymorphic: true
  has_many :esp_rules_lists, dependent: :destroy
  has_many :exported_leads, dependent: :nullify

  accepts_nested_attributes_for :esp_rules_lists, allow_destroy: true

  validates :delay_in_hours, numericality: { greater_than_or_equal_to: 0 }
  validate :must_have_lists

  def split?
    esp_rules_lists.below_limit.count > 1
  end

  def should_send_now?(datetime)
    datetime.beginning_of_hour == Time.zone.now.beginning_of_hour - delay_in_hours.hours
  end

  def delay_passed?
    created_at < delay_in_hours.hours.ago.beginning_of_hour
  end

  def must_have_lists
    if esp_rules_lists.empty? or esp_rules_lists.all? { |list| list.marked_for_destruction? }
      errors.add(:base, 'Must have at least one ESP rule list')
    end
  end
end
