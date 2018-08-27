class EmailMarketerMapping < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  def start_from
    last_transfer_at? ? last_transfer_at.to_date : start_date
  end
end
