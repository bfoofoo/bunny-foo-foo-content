class Article < ApplicationRecord
  belongs_to :category
  belongs_to :website
  belongs_to :formsite, optional: true

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
