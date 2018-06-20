ActiveAdmin.register Article do
  permit_params :name, :content, :short, :slug, :cover_image
end
