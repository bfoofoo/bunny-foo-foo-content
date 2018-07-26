class Ad < ApplicationRecord
  has_many :websites
  has_many :formsites
end
