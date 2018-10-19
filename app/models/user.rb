class User < ApplicationRecord
  include Esp::LinkableMethods

  acts_as_paranoid

  has_many :formsite_users
  has_many :formsites, through: :formsite_users
  has_many :formsite_user_answers
  has_many :leads

  accepts_nested_attributes_for :formsite_users
  accepts_nested_attributes_for :formsites

  scope :unsubscribed, -> { where(unsubscribed: true) }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
