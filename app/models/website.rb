class Website < ApplicationRecord
  has_many :categories
  has_many :articles
end
