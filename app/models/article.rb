class Article < ApplicationRecord
  acts_as_paranoid

  belongs_to :category
  belongs_to :website, optional: true
  belongs_to :formsite, optional: true
  has_many :articles_leadgen_rev_sites
  has_many :leadgen_rev_sites, through: :articles_leadgen_rev_sites

  mount_base64_uploader :cover_image, CommonUploader

  before_save :update_slug

  validates :name, presence: true

  private

  def update_slug
    if self.slug.blank?
      self.slug = self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    else
      self.slug = self.slug.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end
  end
end
