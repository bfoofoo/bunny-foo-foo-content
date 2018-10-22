ActiveAdmin.register LeadgenRefSite do
  permit_params :name, :description, :url,
                :droplet_id, :droplet_ip, :zone_id,
                :repo_url, :ad_client, :shortname,
                :favicon_image, :logo_image, :text_file,
                :is_thankyou, :is_checkboxes, :is_phone_number, :form_box_title_text,
                product_card_ids: [],
                product_cards_attributes: [:id, :title, :description, :image, :rate, :website_id, :_create, :_destroy],
                ad_ids: [],
                
                ads_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy],
                trackers_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy],
                advertisements_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy]

  filter :id          

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
    actions
  end

  form do |f|
    tabs do
      tab 'SITE SETTINGS' do
        f.object.repo_url = f.object.repo_url.blank? ? 'git@github.com:flywithmemsl/bff-template.git' : f.object.repo_url
        f.inputs 'LeadgenRefSite' do

          f.input :description
          f.input :text_file
          f.input :shortname, :label => 'Discus shortname'

          f.input :name
          f.input :is_thankyou
          f.input :is_checkboxes
          f.input :is_phone_number
          f.input :favicon_image
          f.input :logo_image
          f.input :background
          f.input :repo_url
          f.input :first_question_code_snippet
          f.input :head_code_snippet
          f.input :first_redirect_url
          f.input :final_redirect_url
          f.input :left_side_content, as: :froala_editor, input_html: f.object.decorate.admin_contet_wysiwyg_config
          f.input :right_side_content, as: :froala_editor, input_html: f.object.decorate.admin_contet_wysiwyg_config
          
          f.input :droplet_ip
          f.input :form_box_title_text

          f.input :ad_client

          f.input :s1_description
          f.input :s2_description
          f.input :s3_description
          f.input :s4_description
          f.input :s5_description
          f.input :affiliate_description
        end
      end

      tab 'ADS AND TRACKER' do
        AD_POSITIONS = ['adSidebar', 'adTop', 'adMiddle', 'adBottom', 'adAppendedToBody', 'adpushup', 'tracker']
        AD_TYPES = ['embed', 'google', 'custom', 'text/javascript', 'autoad']

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
end
