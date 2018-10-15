class User < ApplicationRecord
  acts_as_paranoid
  
  has_many :formsite_users
  has_many :formsites, through: :formsite_users
  has_many :formsite_user_answers
  has_many :leads

  has_many :aweber_list_users, class_name: 'AweberListUser', as: :linkable
  has_many :aweber_lists, through: :aweber_list_user, source: :list, source_type: 'AweberList'
  has_many :adopia_list_users, class_name: 'AdopiaListUser', as: :linkable
  has_many :adopia_lists, through: :adopia_list_user, source: :list, source_type: 'AdopiaList'

  accepts_nested_attributes_for :formsite_users
  accepts_nested_attributes_for :formsites

  scope :added_to_aweber, -> { joins(:aweber_list).distinct }
  scope :added_to_adopia, -> { joins(:adopia_list).distinct }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def sent_to_aweber?
    aweber_list_users.present?
  end

  def sent_to_aweber_list?(list)
    aweber_list_users.where(list: list).exists?
  end

  def sent_to_adopia?
    adopia_list_users.present?
  end

  def sent_to_adopia_list?(list)
    adopia_list_users.where(list: list).present?
  end
end
