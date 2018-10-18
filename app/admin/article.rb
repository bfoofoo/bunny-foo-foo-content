ActiveAdmin.register Article do
  permit_params :name, :slug, :content, :short , :cover_image, :website_id, :category_id, :formsite_id, :leadgen_ref_site_id

  before_create do |article|
    ["alt", "alignment", "scale", "width", "_wysihtml5_mode", "commit"].map{|i| params.delete(i)}
  end
  index do |poll|
    selectable_column
    id_column
    column :name
    column :slug
    column :short

    column "Website" do |article|
      link_to(article.website.name, admin_website_path(article.website)) if !article.website.blank?
    end

    column "Leadgen Site" do |article|
      link_to(article.formsite.name, admin_formsite_path(article.formsite)) if !article.formsite.blank?
    end

    actions
  end

  form do |f|
    f.inputs '' do
      f.input :name
      f.input :slug
      f.input :content, as: :wysihtml5, commands: 'all', blocks: 'all', height: 'huge'
      f.input :short
      f.input :cover_image
      f.input :website_id, :label => 'Website', :as => :select, :collection => Website.all.map{|u| ["#{u.name}", u.id]}
      f.input :formsite_id, :label => 'Leadgen Site', :as => :select, :collection => Formsite.all.map{|u| ["#{u.name}", u.id]}

      f.input :leadgen_ref_site_id, :label => 'Leadgen Ref Site', :as => :select, :collection => LeadgenRefSite.all.map{|u| ["#{u.name}", u.id]}

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
