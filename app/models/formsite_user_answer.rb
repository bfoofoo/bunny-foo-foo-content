class FormsiteUserAnswer < ApplicationRecord
  belongs_to :formsite_user, optional: true
  belongs_to :formsite, optional: true
  belongs_to :question, optional: true

  scope :between_dates, -> (start_date, end_date) { 
    where("created_at >= ? AND created_at <= ?", start_date, end_date)
  }
end
