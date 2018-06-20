ActiveAdmin.register Article do
  permit_params :name, :content, :short, :slug, :cover_image, :website_id, :category_id


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
end
