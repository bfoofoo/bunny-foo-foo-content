ActiveAdmin.register Category do
  permit_params :name, :description, :slug, :website_id
end
