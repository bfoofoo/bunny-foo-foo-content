class EmailMarketerMapping < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  validates :delay_in_hours, numericality: { greater_than_or_equal_to: 0, allow_blank: true }

  def start_from
    last_transfer_at? ? last_transfer_at.to_date : start_date
  end
end
