class Website < ApplicationRecord
  acts_as_paranoid

  has_and_belongs_to_many :categories
  has_many :questions, dependent: :destroy
  has_many :articles, dependent: :restrict_with_error
  has_many :website_ads, dependent: :restrict_with_error
  has_many :ads, :through => :website_ads

  has_many :advertisements, -> { advertisements } , :through => :website_ads, source: :ad
  has_many :trackers, -> { trackers } , :through => :website_ads, source: :ad
  has_many :widgets, -> { trackers } , :through => :website_ads, source: :ad

  has_many :formsite_users, dependent: :restrict_with_error, foreign_key: :website_id
  has_many :users, through: :formsite_users do
    def verified
      where("formsite_users.is_verified= ?", true)
    end

    def unverified
      where("formsite_users.is_verified= ?", false)
    end
  end

  has_many :product_cards, dependent: :destroy
  has_many :esp_rules, as: :source, class_name: 'EspRules::Website'

  accepts_nested_attributes_for :categories, allow_destroy: true
  accepts_nested_attributes_for :website_ads, allow_destroy: true
  accepts_nested_attributes_for :ads, allow_destroy: true
  accepts_nested_attributes_for :trackers, allow_destroy: true
  accepts_nested_attributes_for :advertisements, allow_destroy: true
  accepts_nested_attributes_for :widgets, allow_destroy: true
  accepts_nested_attributes_for :product_cards, allow_destroy: true
  accepts_nested_attributes_for :questions, allow_destroy: true
  accepts_nested_attributes_for :formsite_users, allow_destroy: true
  accepts_nested_attributes_for :esp_rules, allow_destroy: true

  after_save :mark_last_question

  validates :name, presence: true, uniqueness: true
  validates_associated :esp_rules

  mount_uploader :favicon_image, CommonUploader
  mount_uploader :logo_image, CommonUploader
  mount_uploader :text_file, TextFileUploader


  def builder_config
    return {
      id: self.id,
      name: self.name,
      description: self.description || '',
      favicon_image: self.favicon_image.url || '',
      logo_image: self.logo_image.url || '',
      text_file: self.text_file.url || '',
      website_id: self.id,
      droplet_ip: self.droplet_ip,
      droplet_id: self.droplet_id,
      zone_id: self.zone_id,
      repo_url: self.repo_url,
      ad_client: self.ad_client || '',
      ads: self.ads,
      type: 'website',
      size_slug: 's-2vcpu-4gb',
      account_id: DigitalOceanAccount.find_by(name: 'BunnyFooFoo')&.id
    }
  end

  def mark_last_question
    return if questions.empty?
    questions.update_all(is_last: false)
    questions.last.mark_as_last!
  end
end
