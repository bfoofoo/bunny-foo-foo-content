class FormsiteAweberList < ApplicationRecord
  belongs_to :formsite
  belongs_to :aweber_list

  validates :delay_in_hours, numericality: { greater_than_or_equal_to: 0 }

  def should_send_now?(datetime)
    datetime.beginning_of_hour == Time.zone.now.beginning_of_hour - delay_in_hours.hours
  end
end
