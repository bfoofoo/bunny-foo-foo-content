class LeadgenRevSiteUser < ApplicationRecord
  TEST_USER_EMAIL="bf@test.com"

  acts_as_paranoid

  belongs_to :leadgen_rev_site
  belongs_to :user, optional: true
  has_many :esp_rules, through: :user
  has_many :esp_rules_lists, through: :esp_rules
  has_many :exported_leads, through: :user

  delegate :email, :sent_to_aweber?, :sent_to_adopia?, :sent_to_elite?, :sent_to_ongage?,
           to: :user, allow_nil: true

  scope :by_s_filter, -> (s_field) {
    where.not("#{s_field}" => nil)
      .where.not("#{s_field}" => "")
  }

  scope :jeft_join_users, -> { joins("LEFT OUTER JOIN users ON leadgen_rev_site_users.user_id = users.id") }

  scope :without_test_users, -> {
    jeft_join_users
      .where("users.email != ? OR leadgen_rev_site_users.user_id IS NULL", TEST_USER_EMAIL)
  }

  scope :only_test_users, -> { includes(:user).where(users: {email: TEST_USER_EMAIL}) }

  scope :is_duplicate, -> { where(is_duplicate: true) }
  scope :is_verified, -> { where(is_verified: true) }

  scope :not_duplicate, -> { where(is_duplicate: false) }
  scope :not_verified, -> { where(is_verified: false) }

  scope :between_dates, -> (start_date, end_date) {
    where("leadgen_rev_site_users.created_at >= ? AND leadgen_rev_site_users.created_at <= ?", start_date, end_date)
  }

  scope :by_email_domain, ->(domain) { joins(:user).where('users.email ~* ?', '@' + domain + '\.\w+$') }

  User::ESP_LIST_TYPES.each do |provider, type|
    define_method :"local_sent_to_#{provider}?" do
      return false unless user_id
      exported_leads
        .joins(:esp_rule)
        .where(exported_leads: { list_type: type, linkable_type: 'User', linkable_id: user_id })
        .where(esp_rules: { source_type: 'LeadgenRevSite', source_id: leadgen_rev_site_id })
        .exists?
    end
  end
end
