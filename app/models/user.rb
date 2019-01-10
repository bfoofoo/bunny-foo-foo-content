class User < ApplicationRecord
  include Esp::LinkableMethods

  acts_as_paranoid

  has_many :formsite_users
  has_many :leadgen_rev_site_users
  has_many :formsites, through: :formsite_users
  has_many :leadgen_rev_sites, through: :leadgen_rev_site_users
  has_many :formsite_user_answers
  has_many :leads
  has_many :esp_rules, as: :source, class_name: 'EspRules::Formsite'
  has_many :esp_rules_lists, through: :esp_rules
  has_many :exported_leads, as: :linkable
  has_many :sms_subscribers, as: :linkable

  store_accessor :custom_fields, *COLOSSUS_CUSTOM_FIELDS

  accepts_nested_attributes_for :formsite_users
  accepts_nested_attributes_for :formsites

  validates :first_name, :last_name, presence: true

  scope :unsubscribed, -> { where.not(unsubscribed_at: nil) }
  scope :unsubscribed_between_dates, -> (start_date, end_date) {
    where("users.unsubscribed_at >= ? AND users.unsubscribed_at <= ?", start_date.beginning_of_day, end_date.end_of_day)
  }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
