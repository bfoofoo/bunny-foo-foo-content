class WebsiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :url, :shortname, :show_popup, :popup_delay, :popup_iframe_urls

  has_many :categories
  has_many :articles
end
