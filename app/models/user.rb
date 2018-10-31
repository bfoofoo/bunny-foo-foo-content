class User < ApplicationRecord
  include Esp::LinkableMethods

  acts_as_paranoid

  has_many :formsite_users
  has_many :formsites, through: :formsite_users
  has_many :formsite_user_answers
  has_many :leads
  has_many :esp_rules, as: :source, class_name: 'EspRules::Formsite'
  has_many :esp_rules_lists, through: :esp_rules

  accepts_nested_attributes_for :formsite_users
  accepts_nested_attributes_for :formsites

  validates :first_name, :last_name, presence: true

  scope :unsubscribed, -> { where(unsubscribed: true) }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
