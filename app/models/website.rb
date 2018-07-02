class Website < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :articles

  accepts_nested_attributes_for :categories

  def builder_config
    return {
      name: self.name
    }
  end
end
