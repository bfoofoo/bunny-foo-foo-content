class WebsiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :url, :shortname
end
