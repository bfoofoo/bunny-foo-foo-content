class User < ApplicationRecord
  has_many :formsite_users
  has_many :formsites, through: :formsite_users
  has_many :formsite_user_answers
  has_many :leads

  has_one :aweber_list_user, class_name: 'AweberListUser'
  has_one :aweber_list, through: :aweber_list_user, source: :list, source_type: 'AweberList'
  has_one :aweber_opener, through: :aweber_list, source: :openers

  accepts_nested_attributes_for :formsite_users
  accepts_nested_attributes_for :formsites

  scope :added_to_aweber, -> { joins(:aweber_list).distinct }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def aweber?
    aweber_list_user.present?
  end
end
