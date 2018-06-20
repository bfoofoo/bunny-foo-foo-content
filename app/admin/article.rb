ActiveAdmin.register Article do
  permit_params :name, :content, :short, :slug, :cover_image


  form do |f|
    f.inputs '' do
      f.input :name
      f.input :slug
      f.input :content, as: :wysihtml5, commands: 'all', blocks: 'all', height: 'huge'
      f.input :short
      f.input :cover_image
      f.actions
    end
  end
end
