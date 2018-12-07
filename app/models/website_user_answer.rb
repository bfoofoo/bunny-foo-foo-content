class WebsiteUserAnswer < ApplicationRecord
    belongs_to :formsite_user
    belongs_to :website, optional: true
    belongs_to :question, optional: true

    scope :between_dates, -> (start_date, end_date) { 
    where("website_user_answers.created_at >= ? AND website_user_answers.created_at <= ?", start_date, end_date)
  }

  scope :uniq_by_website_user, -> () { select('DISTINCT ON (website_user_id) *') }

end
