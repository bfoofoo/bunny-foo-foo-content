class ArticlePopupSerializer < ActiveModel::Serializer
  attributes :id, :article_id, :leadgen_rev_site_id, :show_popup, :popup_iframe_urls, :popup_delay, :leadgen_rev_site
end
