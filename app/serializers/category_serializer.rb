class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :slug
  belongs_to :website, serializer: WebsiteSerializer
end
