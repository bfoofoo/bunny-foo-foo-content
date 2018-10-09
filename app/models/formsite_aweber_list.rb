class FormsiteAweberList < ApplicationRecord
  belongs_to :formsite
  belongs_to :aweber_list

  validates :delay_in_hours, numericality: { greater_than_or_equal_to: 0 }
end
