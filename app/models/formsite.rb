class Formsite < ApplicationRecord
  OPENPOSITION_NAME = "openposition.us"
  acts_as_paranoid
  
  has_and_belongs_to_many :categories
  has_many :formsite_users, dependent: :restrict_with_error
  has_many :users, :through => :formsite_users do
    def verified
      where("formsite_users.is_verified= ?", true)
    end
    
    def unverified
      where("formsite_users.is_verified= ?", false)
    end
  end
  
  has_many :questions, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :esp_rules, as: :source, class_name: 'EspRules::Formsite'

  has_many :formsite_ads, dependent: :destroy
  has_many :ads, through: :formsite_ads

  belongs_to :digital_ocean_account, foreign_key: :account_id

  accepts_nested_attributes_for :categories, allow_destroy: true
  accepts_nested_attributes_for :esp_rules, allow_destroy: true

  accepts_nested_attributes_for :formsite_ads, allow_destroy: true
  accepts_nested_attributes_for :ads, allow_destroy: true

  accepts_nested_attributes_for :formsite_users, allow_destroy: true
  accepts_nested_attributes_for :users, allow_destroy: true

  accepts_nested_attributes_for :questions, allow_destroy: true

  mount_uploader :favicon_image, CommonUploader
  mount_uploader :logo_image, CommonUploader
  mount_uploader :background, CommonUploader

  validates_associated :esp_rules
  validates :name, presence: true, uniqueness: true

  after_save :mark_last_question

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
        type: 'formsite',
        size_slug: self.size_slug,
        account_id: self.account_id
    }
  end

  def mark_last_question
    return if questions.empty?
    questions.update_all(is_last: false)
    questions.last.mark_as_last!
  end
end
