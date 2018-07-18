ActiveAdmin.register ProductCard do
  menu label:  "Product cards / Offer Walls"
  permit_params :id, :title, :description, :image, :rate, :website_id, :url
end
