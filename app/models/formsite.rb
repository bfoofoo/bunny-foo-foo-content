class Formsite < ApplicationRecord

  
  has_many :formsite_users, dependent: :destroy
  has_many :users, :through => :formsite_users do
    def verified
      where("formsite_users.is_verified= ?", true)
    end
    
    def unverified
      where("formsite_users.is_verified= ?", false)
    end
  end
  
  has_many :questions, dependent: :destroy
  
  has_many :formsite_aweber_lists, dependent: :destroy
  has_many :aweber_lists, :through => :formsite_aweber_lists

  has_many :formsite_ads, dependent: :destroy
  has_many :ads, :through => :formsite_ads

  accepts_nested_attributes_for :formsite_aweber_lists, allow_destroy: true
  accepts_nested_attributes_for :aweber_lists, allow_destroy: true

  accepts_nested_attributes_for :formsite_ads, allow_destroy: true
  accepts_nested_attributes_for :ads, allow_destroy: true

  accepts_nested_attributes_for :formsite_users, allow_destroy: true
  accepts_nested_attributes_for :users, allow_destroy: true

  accepts_nested_attributes_for :questions, allow_destroy: true

  mount_uploader :favicon_image, CommonUploader
  mount_uploader :logo_image, CommonUploader
  mount_uploader :background, CommonUploader

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
        type: 'formsite'
    }
  end
end
