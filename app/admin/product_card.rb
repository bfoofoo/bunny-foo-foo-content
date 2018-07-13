ActiveAdmin.register ProductCard do
  permit_params :id, :title, :description, :image, :rate
end
