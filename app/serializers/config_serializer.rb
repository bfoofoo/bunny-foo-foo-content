class ConfigSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :slug
end
