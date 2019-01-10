class CustomField < ApplicationRecord
  acts_as_paranoid

  has_many :questions

  validates :name, presence: true, uniqueness: true
end
