ActiveAdmin.register ProductCard do
  permit_params :id, :title, :description, :image, :rate, :website_id
end
