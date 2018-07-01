ActiveAdmin.register Website do
  permit_params :name, :description, :url

  index do
    column :id
    column :name
    column :description
    column :url
    column :created_at
    actions defaults: true do |website|
      link_to 'Duplicate', clone_admin_website_path(website)
    end
  end

  # sidebar "Actions", only: [:show] do
  #   attributes_table_for website do
  #     row '1' do
  #       link_to setup_api_v1_websites_path(website), class: 'button', remote: true do
  #         'SETUP WEBSITE'
  #       end
  #     end
  #
  #     row '2' do
  #       link_to build_api_v1_websites_path(website), class: 'button', remote: true do
  #         'REBUILD WEBSITE'
  #       end
  #     end
  #   end
  # end

  action_item :only => :show do
    link_to("Make a Copy", clone_admin_website_path(id: website.id))
  end

  action_item :only => :show do
    link_to setup_api_v1_websites_path(website), class: 'button', remote: true do
      'SETUP WEBSITE'
    end
  end
  
  action_item :only => :show do
    link_to build_api_v1_websites_path(website), class: 'button', remote: true do
      'REBUILD WEBSITE'
    end
  end

  member_action :clone, method: :get do
    website = Website.find(params[:id])
    @website = website.dup
    render :new, layout: false
  end
end
