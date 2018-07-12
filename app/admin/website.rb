ActiveAdmin.register Website do
  permit_params :name, :description, :url, :droplet_id, :droplet_ip, :zone_id, :repo_url, :ad_client, :favicon_image, :logo_image, ad_ids: [], ads_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy]

  AD_POSITIONS = ['adSidebar', 'adTop', 'adMiddle', 'adBottom', 'adAppendedToBody', 'adpushup', 'tracker']
  AD_TYPES = ['embed', 'google', 'custom', 'text/javascript']

  index do
    column :id
    column :name
    column :description
    column :droplet_id
    column :droplet_ip
    column :zone_id
    column :created_at
    column :ad_client
    actions defaults: true do |website|
      link_to 'Duplicate', clone_admin_website_path(website)
    end
  end

  form do |f|
    tabs do
      tab 'SITE SETTINGS' do
        f.object.repo_url = f.object.repo_url.blank? ? 'git@github.com:flywithmemsl/bff-template.git' : f.object.repo_url
        f.inputs 'Website' do
          f.input :name
          f.input :description
          f.input :favicon_image
          f.input :logo_image
          f.input :repo_url
          f.input :droplet_ip
          f.input :ad_client
        end
      end
      tab 'ADS' do
        f.inputs 'Ads' do
          f.has_many :ads, allow_destroy: true, new_record: true do |ff|
            ff.semantic_errors
            ff.input :position, :as => :select, :collection => AD_POSITIONS
            ff.input :variety, :as => :select, :collection => AD_TYPES
            ff.input :widget
            ff.input :google_id, :label => 'Google ID'
            ff.input :innerHTML
          end
        end
      end
    end
    f.actions
  end

  action_item :copy, :only => :show do
    link_to("Make a Copy", clone_admin_website_path(id: website.id))
  end

  action_item :setup, :only => :show do
    link_to setup_api_v1_websites_path(website), class: 'button builder_action', "data-type" => "json", remote: true do
      '<span>Setup Website</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end if website.droplet_ip.blank?
  end

  action_item :rebuild, :only => :show do
    link_to build_api_v1_websites_path(website), class: 'button builder_action', "data-type" => "json", remote: true do
      '<span>Rebuild Website</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end if !website.droplet_ip.blank?
  end

  action_item :rebuild_old_site, :only => :show do
    link_to rebuild_old_api_v1_websites_path(website), class: 'button builder_action', "data-type" => "json", remote: true do
      '<span>Rebuild Old Website</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end if !website.droplet_ip.blank?
  end

  member_action :clone, method: :get do
    website = Website.find(params[:id])
    @website = website.dup
    render :new, layout: false
  end
end
