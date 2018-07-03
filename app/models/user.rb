class User < ApplicationRecord
  has_many :formsite_users
  has_many :formsites, :through => :formsite_users

  accepts_nested_attributes_for :formsite_users
  accepts_nested_attributes_for :formsites
end
