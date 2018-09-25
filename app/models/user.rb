class User < ApplicationRecord
  acts_as_paranoid
  
  has_many :formsite_users
  has_many :formsites, through: :formsite_users
  has_many :formsite_user_answers
  has_many :leads

  has_one :aweber_list_user, class_name: 'AweberListUser', as: :linkable
  has_one :aweber_list, through: :aweber_list_user, source: :list, source_type: 'AweberList'
  has_one :maropost_list_user, class_name: 'MaropostListUser', as: :linkable
  has_one :maropost_list, through: :maropost_list_user, source: :list, source_type: 'MaropostList'

  accepts_nested_attributes_for :formsite_users
  accepts_nested_attributes_for :formsites

  scope :added_to_aweber, -> { joins(:aweber_list).distinct }
  scope :added_to_maropost, -> { joins(:maropost_list).distinct }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def aweber?
    aweber_list_user.present?
  end

  def maropost?
    maropost_list_user.present?
  end
end
