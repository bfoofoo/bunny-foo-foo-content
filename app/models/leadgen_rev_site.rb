class LeadgenRevSite < ApplicationRecord
  acts_as_paranoid

  has_and_belongs_to_many :categories
  has_many :leadgen_rev_site_users, dependent: :restrict_with_error
  has_many :users, through: :leadgen_rev_site_users do
    def verified
      where("leadgen_rev_site_users.is_verified= ?", true)
    end

    def unverified
      where("leadgen_rev_site_users.is_verified= ?", false)
    end
  end

  has_many :leadgen_rev_site_ads, dependent: :restrict_with_error
  has_many :ads, through: :leadgen_rev_site_ads

  has_many :pixel_code_snippets, dependent: :destroy
  has_many :leadgen_rev_site_popups, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :prelander_questions, -> { for_prelander },  dependent: :destroy, class_name: 'Question'
  has_many :articles_leadgen_rev_sites
  has_many :articles, through: :articles_leadgen_rev_sites, dependent: :destroy
  has_many :product_cards_leadgen_rev_sites
  has_many :product_cards, through: :product_cards_leadgen_rev_sites, dependent: :destroy
  has_many :esp_rules, as: :source, class_name: 'EspRules::LeadgenRevSite'
  has_many :advertisements, -> { advertisements } , through: :leadgen_rev_site_ads, source: :ad
  has_many :trackers, -> { trackers } , through: :leadgen_rev_site_ads, source: :ad
  has_many :widgets, -> { widgets } , through: :leadgen_rev_site_ads, source: :ad
  has_many :sms_subscribers, as: :source
  has_many :cep_rules, dependent: :destroy
  has_many :cep_groups, through: :cep_rules, dependent: :destroy
  has_many :leadgen_entries, dependent: :destroy

  belongs_to :digital_ocean_account, foreign_key: :account_id

  accepts_nested_attributes_for :categories, allow_destroy: true
  accepts_nested_attributes_for :leadgen_rev_site_popups, allow_destroy: true
  accepts_nested_attributes_for :ads, allow_destroy: true
  accepts_nested_attributes_for :trackers, allow_destroy: true
  accepts_nested_attributes_for :widgets, allow_destroy: true
  accepts_nested_attributes_for :esp_rules, allow_destroy: true
  accepts_nested_attributes_for :leadgen_rev_site_users, allow_destroy: true
  accepts_nested_attributes_for :advertisements, allow_destroy: true
  accepts_nested_attributes_for :product_cards, allow_destroy: true
  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates_associated :esp_rules

  after_save :mark_last_question

  mount_uploader :favicon_image, CommonUploader
  mount_uploader :logo_image, CommonUploader
  mount_uploader :background, CommonUploader
  mount_uploader :text_file, TextFileUploader

  def mark_last_question
    return if questions.empty?
    questions.update_all(is_last: false)
    questions.last.mark_as_last!
  end

  def builder_config
    {
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
      type: 'leadgen_rev_site',
      size_slug: self.size_slug,
      account_id: self.account_id
    }
  end
end
