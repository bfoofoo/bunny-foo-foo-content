class LeadgenRevSite < ApplicationRecord
  acts_as_paranoid

  has_and_belongs_to_many :categories

  has_many :leadgen_rev_site_ads, dependent: :restrict_with_error
  has_many :ads, :through => :LeadgenRevSiteAd

  has_many :advertisements, -> { advertisements } , :through => :LeadgenRevSiteAd, source: :ad
  has_many :trackers, -> { trackers } , :through => :LeadgenRevSiteAd, source: :ad

  accepts_nested_attributes_for :categories, allow_destroy: true
  accepts_nested_attributes_for :ads, allow_destroy: true
  accepts_nested_attributes_for :trackers, allow_destroy: true
  accepts_nested_attributes_for :advertisements, allow_destroy: true
  # accepts_nested_attributes_for :product_cards, allow_destroy: true

  validates :name, presence: true

  mount_uploader :favicon_image, CommonUploader
  mount_uploader :logo_image, CommonUploader
  mount_uploader :background, CommonUploader
end
