class FormsiteUser < ApplicationRecord
  belongs_to :formsite
  belongs_to :user, optional: true

  delegate :email, to: :user, allow_nil: true

  scope :by_s_filter, -> (s_field) { 
    where.not("#{s_field}" => nil)
    .where.not("#{s_field}" => "")
  }

  scope :between_dates, -> (start_date, end_date) { 
    where("created_at >= ? AND created_at <= ?", start_date, end_date)
  }

end
