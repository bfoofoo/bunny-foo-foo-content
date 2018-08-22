class WebsiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :url, :shortname

  has_many :categories
  has_many :articles
end
