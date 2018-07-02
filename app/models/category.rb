class Category < ApplicationRecord
  has_many :articles
  has_and_belongs_to_many :websites
  accepts_nested_attributes_for :websites
end
