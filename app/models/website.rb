class Website < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :articles, dependent: :destroy
  has_many :website_ads, dependent: :destroy
  has_many :ads, :through => :website_ads

  accepts_nested_attributes_for :categories
  accepts_nested_attributes_for :website_ads
  accepts_nested_attributes_for :ads


  validates :name, presence: true

  mount_uploader :favicon_image, CommonUploader
  mount_uploader :logo_image, CommonUploader

  def builder_config
    return {
      name: self.name,
      description: self.description || '',
      favicon_image: self.favicon_image.url || '',
      logo_image: self.logo_image.url || '',
      website_id: self.id,
      droplet_ip: self.droplet_ip,
      droplet_id: self.droplet_id,
      zone_id: self.zone_id,
      repo_url: self.repo_url,
      ad_client: self.ad_client || '',
      ads: self.ads,
      type: 'website'
    }
  end
end
