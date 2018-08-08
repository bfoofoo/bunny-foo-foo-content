class User < ApplicationRecord
  has_many :formsite_users
  has_many :formsites, :through => :formsite_users
  has_many :formsite_user_answers

  accepts_nested_attributes_for :formsite_users
  accepts_nested_attributes_for :formsites

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
