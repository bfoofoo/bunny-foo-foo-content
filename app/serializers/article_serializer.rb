class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :short, :slug, :cover_image
  belongs_to :category, serializer: CategorySerializer
end
