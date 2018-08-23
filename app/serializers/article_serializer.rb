class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :short, :slug, :cover_image, :category_id

  # belongs_to :category, serializer: CategorySerializer
end
