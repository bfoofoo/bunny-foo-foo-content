class FormsiteUser < ApplicationRecord
  TEST_USER_EMAIL="bf@test.com"
  
  acts_as_paranoid
  
  belongs_to :formsite
  belongs_to :user, optional: true

  delegate :email, to: :user, allow_nil: true

  scope :by_s_filter, -> (s_field) { 
    where.not("#{s_field}" => nil)
    .where.not("#{s_field}" => "")
  }

  scope :without_test_users, -> () { includes(:user).where.not(users: {email: TEST_USER_EMAIL}) }
  scope :only_test_users, -> () { includes(:user).where(users: {email: TEST_USER_EMAIL}) }

  scope :is_duplicate, -> () { where(is_duplicate: true) }
  scope :is_verified, -> () { where(is_verified: true) }

  scope :not_duplicate, -> () { where(is_duplicate: false) }
  scope :not_verified, -> () { where(is_verified: false) }

  scope :between_dates, -> (start_date, end_date) { 
    where("created_at >= ? AND created_at <= ?", start_date, end_date)
  }

end
