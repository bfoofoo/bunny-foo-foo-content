class LeadgenRevSiteUserAnswer < ApplicationRecord
  belongs_to :leadgen_rev_site_user, optional: true
  belongs_to :leadgen_rev_site, optional: true
  belongs_to :question, optional: true

  scope :between_dates, -> (start_date, end_date) { 
    where("leadgen_rev_site_user_answers.created_at >= ? AND leadgen_rev_site_user_answers.created_at <= ?", start_date, end_date)
  }

  scope :uniq_by_leadgen_rev_site_user, -> () { select('DISTINCT ON (leadgen_rev_site_user_id) *') }


end
