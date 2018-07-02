ActiveAdmin.register Article do
  permit_params :name, :content, :short, :slug, :cover_image, :website_id, :category_id

  before_create do |article|
    ["alt", "alignment", "scale", "width", "_wysihtml5_mode", "commit"].map{|i| params.delete(i)}
  end

  form do |f|
    f.inputs '' do
      f.input :name
      f.input :slug
      f.input :content, as: :wysihtml5, commands: 'all', blocks: 'all', height: 'huge'
      f.input :short
      f.input :cover_image
      f.input :website_id, :label => 'Website', :as => :select, :collection => Website.all.map{|u| ["#{u.name}", u.id]}
      f.input :category_id, :label => 'Category', :as => :select, :collection => Category.all.map{|u| ["#{u.name}", u.id]}
      f.actions
    end
  end

  action_item :copy, :only => :show do
    link_to("Make a Copy", clone_admin_article_path(id: params[:id]))
  end

  action_item :new, :only => :show do
    link_to("Add new", new_admin_article_path)
  end

  member_action :clone, method: :get do
    article = Article.find(params[:id])
    @article = article.dup
    render :new, layout: false
  end
end
