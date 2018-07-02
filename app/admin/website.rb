ActiveAdmin.register Website do
  permit_params :name, :description, :url, :droplet_id, :droplet_ip, :zone_id

  index do
    column :id
    column :name
    column :description
    column :url
    column :droplet_id
    column :droplet_ip
    column :zone_id
    column :url
    column :created_at
    actions defaults: true do |website|
      link_to 'Duplicate', clone_admin_website_path(website)
    end
  end

  action_item :copy, :only => :show do
    link_to("Make a Copy", clone_admin_website_path(id: website.id))
  end

  action_item :setup, :only => :show do
    link_to setup_api_v1_websites_path(website), class: 'button', remote: true do
      'Setup Website'
    end
  end

  action_item :rebuild, :only => :show do
    link_to build_api_v1_websites_path(website), class: 'button', remote: true do
      'Rebuild Website'
    end
  end

  member_action :clone, method: :get do
    website = Website.find(params[:id])
    @website = website.dup
    render :new, layout: false
  end
end
