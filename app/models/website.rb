class Website < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :articles

  accepts_nested_attributes_for :categories

  validates :name, presence: true

  def builder_config
    return {
      name: self.name,
      description: self.description || '',
      website_id: self.id,
      droplet_ip: self.droplet_ip,
      droplet_id: self.droplet_id,
      zone_id: self.zone_id,
      repo_url: self.repo_url,
      ad_client: self.ad_client || '',
      ad_sidebar_id: self.ad_sidebar_id || '',
      ad_top_id: self.ad_top_id || '',
      ad_middle_id: self.ad_middle_id || '',
      ad_bottom_id: self.ad_bottom_id || '',
      type: 'website'
    }
  end
end
