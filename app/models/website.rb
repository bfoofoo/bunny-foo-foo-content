class Website < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :articles, dependent: :destroy
  has_many :website_ads, dependent: :destroy
  has_many :ads, :through => :website_ads

  has_many :advertisements, -> { advertisements } , :through => :website_ads, source: :ad
  has_many :trackers, -> { trackers } , :through => :website_ads, source: :ad

  has_many :product_cards, dependent: :destroy

  accepts_nested_attributes_for :categories, allow_destroy: true
  accepts_nested_attributes_for :website_ads, allow_destroy: true
  accepts_nested_attributes_for :ads, allow_destroy: true
  accepts_nested_attributes_for :trackers, allow_destroy: true
  accepts_nested_attributes_for :advertisements, allow_destroy: true
  accepts_nested_attributes_for :product_cards, allow_destroy: true


  validates :name, presence: true

  mount_uploader :favicon_image, CommonUploader
  mount_uploader :logo_image, CommonUploader

  def builder_config
    return {
      id: self.id,
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
