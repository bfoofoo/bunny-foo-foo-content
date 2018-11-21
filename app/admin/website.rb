ActiveAdmin.register Website do
  permit_params :name, :description, :url,
                :droplet_id, :droplet_ip, :zone_id,
                :repo_url, :ad_client, :shortname,
                :favicon_image, :logo_image, :text_file, :show_popup, :popup_delay, popup_iframe_urls: [],
                product_card_ids: [],
                product_cards_attributes: [:id, :title, :description, :image, :rate, :website_id, :_create, :_destroy],
                ad_ids: [],
                
                ads_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy],
                trackers_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy],
                advertisements_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy]

  before_save do |website|
    website.popup_iframe_urls.reject!(&:blank?)
  end

  index do
    column :id
    column :name
    column :description
    column :droplet_id
    column :droplet_ip
    column :zone_id
    column :created_at
    column :ad_client
    column :shortname
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
          f.input :text_file
          f.input :logo_image
          f.input :repo_url
          f.input :droplet_ip
          f.input :ad_client
          f.input :shortname, :label => 'Discus shortname'
        end
      end

      form_builder = Admin::FormBuilders::Website.new(f)
      AD_POSITIONS = %w(adSidebar adTop adMiddle adBottom adAppendedToBody adpushup tracker widgetSidebar widgetTop widgetBottom)
      AD_TYPES = %w(embed google custom text/javascript autoad)

      tab 'ADS' do
        f.inputs 'Ads' do
          form_builder.ads_nested_fields(
            :advertisements,
            {allow_destroy: true, new_record: true},
            positions: AD_POSITIONS - ["tracker"], 
            types: AD_TYPES
          )
        end
      end

      tab 'Trackers' do
        form_builder = Admin::FormBuilders::Website.new(f)
        f.inputs 'Ads' do
          form_builder.ads_nested_fields(
            :trackers,
            {allow_destroy: true, new_record: true},
            positions: AD_POSITIONS & ["tracker"],
            types: AD_TYPES - ['google']
          )
        end
      end

      tab 'Popup' do
        f.inputs "Popups" do
          f.input :show_popup
          f.input :popup_delay
          f.input :popup_iframe_urls, as: :array
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

  member_action :clone, method: :get do
    website = Website.find(params[:id])
    @website = website.dup
    render :new, layout: false
  end
end
