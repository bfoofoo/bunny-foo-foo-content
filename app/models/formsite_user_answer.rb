class FormsiteUserAnswer < ApplicationRecord
  belongs_to :formsite_user, optional: true
  belongs_to :formsite, optional: true
  belongs_to :question, optional: true

  scope :between_dates, -> (start_date, end_date) { 
    where("formsite_user_answers.created_at >= ? AND formsite_user_answers.created_at <= ?", start_date, end_date)
  }

  scope :uniq_by_formsite_user, -> () { select('DISTINCT ON (formsite_user_id) *') }


end
