class Website < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :articles

  accepts_nested_attributes_for :categories

  def builder_config
    return {
      name: self.name,
      website_id: self.id,
      droplet_ip: self.droplet_ip,
      droplet_id: self.droplet_id,
      zone_id: self.zone_id
    }
  end
end
