class Website < ApplicationRecord
  has_many :categories
  has_many :articles

  def builder_config
    return {
      name: self.name
    }
  end
end
