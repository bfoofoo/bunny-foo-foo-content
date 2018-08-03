class Article < ApplicationRecord
  include Swagger::Blocks
  belongs_to :category
  belongs_to :website

  swagger_schema :Article do
    key :required, [:id, :name, :website_id, :category_id]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :slug do
      key :type, :string
    end
    property :content do
      key :type, :string
    end
    property :short do
      key :type, :string
    end
    property :cover_image do
      key :type, :string
    end
    property :website_id do
      key :type, :integer
    end
    property :category_id do
      key :type, :integer
    end
  end

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
