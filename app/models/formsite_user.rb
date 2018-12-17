class FormsiteUser < ApplicationRecord
  TEST_USER_EMAIL="bf@test.com"

  acts_as_paranoid

  belongs_to :formsite
  belongs_to :website
  belongs_to :user, optional: true
  has_many :esp_rules, through: :formsite
  has_many :esp_rules_lists, through: :esp_rules
  has_many :exported_leads, through: :user

  delegate :email, :sent_to_adopia?, :sent_to_elite?, :sent_to_netatlantic?, :sent_to_mailgun?,
           :sent_to_onepoint?, :sent_to_sparkpost?, :sent_to_getresponse?,  :sent_to_allinbox?,   :sent_to_constantcontact?,
           to: :user, allow_nil: true

  scope :by_s_filter, -> (s_field) {
    where.not("#{s_field}" => nil)
      .where.not("#{s_field}" => "")
  }

  scope :jeft_join_users, -> () { joins("LEFT OUTER JOIN users ON formsite_users.user_id = users.id") }

  scope :without_test_users, -> () {
    jeft_join_users
      .where("users.email != ? OR formsite_users.user_id IS NULL", TEST_USER_EMAIL)
  }

  scope :only_test_users, -> () { includes(:user).where(users: {email: TEST_USER_EMAIL}) }

  scope :is_duplicate, -> () { where(is_duplicate: true) }
  scope :is_verified, -> () { where(is_verified: true) }

  scope :not_duplicate, -> () { where(is_duplicate: false) }
  scope :not_verified, -> () { where(is_verified: false) }

  scope :between_dates, -> (start_date, end_date) {
    where("formsite_users.created_at >= ? AND formsite_users.created_at <= ?", start_date, end_date)
  }

  scope :by_email_domain, ->(domain) { joins(:user).where('users.email ~* ?', '@' + domain + '\.\w+$') }

  def full_name
    if user&.first_name.blank? && user&.last_name.blank? && !user.blank?
      user.email
    elsif !user&.first_name.blank? || !user&.last_name.blank?
      "#{user&.first_name} #{user&.last_name}"
    end
  end

  User::ESP_LIST_TYPES.each do |provider, type|
    define_method :"local_sent_to_#{provider}?" do
      return false unless user_id
      exported_leads
        .joins(:esp_rule)
        .where(exported_leads: { list_type: type, linkable_type: 'User', linkable_id: user_id })
        .where(esp_rules: { source_type: 'Formsite', source_id: formsite_id })
        .exists?
    end
  end
end
