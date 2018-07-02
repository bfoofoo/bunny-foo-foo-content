class Article < ApplicationRecord
  belongs_to :category
  belongs_to :website

  mount_uploader :cover_image, CommonUploader

  before_save :update_slug

  private

  def update_slug
    unless slug_changed?
      self.slug = self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    else
      self.slug = self.slug.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end
  end
end
