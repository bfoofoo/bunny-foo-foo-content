class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :slug, :websites
  # has_and_belongs_to_many :website, serializer: WebsiteSerializer
end
