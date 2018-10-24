class Category < ApplicationRecord
  has_many :articles
  has_and_belongs_to_many :websites
  accepts_nested_attributes_for :websites

  has_and_belongs_to_many :formsites
  accepts_nested_attributes_for :formsites
  
  has_and_belongs_to_many :leadgen_rev_sites
  accepts_nested_attributes_for :leadgen_rev_sites
end
