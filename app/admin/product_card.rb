ActiveAdmin.register ProductCard do
  menu label:  "Product cards / Offer Walls"
  permit_params :id, :title, :description, :image, :rate, :website_id, :url

  action_item :copy, :only => :show do
    link_to("Make a Copy", clone_admin_product_card_path(id: params[:id]))
  end

  member_action :clone, method: :get do
    product_card = ProductCard.find(params[:id])
    @product_card = product_card.dup
    render :new, layout: false
  end
end
