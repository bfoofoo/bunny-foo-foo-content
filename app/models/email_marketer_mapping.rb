class EmailMarketerMapping < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  validates :delay_in_hours, numericality: { greater_than_or_equal_to: 0 }

  scope :by_type, -> (type) { where(destination_type: type) }

  def should_send_now?(datetime)
    datetime.beginning_of_hour == Time.zone.now.beginning_of_hour - delay_in_hours.hours
  end

  def start_from
    last_transfer_at? ? last_transfer_at.to_date : start_date
  end
end
