ActiveAdmin.register Category do
  permit_params :name, :description, :slug
end
