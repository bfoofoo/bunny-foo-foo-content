class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :slug
  has_many :websites
  has_many :formsites
  # has_and_belongs_to_many :website, serializer: WebsiteSerializer
end
