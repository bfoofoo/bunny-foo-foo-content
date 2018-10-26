ActiveAdmin.register LeadgenRevSite do
  permit_params :name, :description, :url,
                :droplet_id, :droplet_ip, :zone_id,
                :repo_url, :ad_client, :shortname, :final_redirect_url,
                :favicon_image, :logo_image, :text_file,
                :is_thankyou, :is_checkboxes, :is_phone_number, :form_box_title_text,
                :left_side_content, :right_side_content,
                :first_question_code_snippet, :head_code_snippet,
                :s1_description, :s2_description, :s3_description, :s4_description, :s5_description, :affiliate_description, :ad_client,
                question_ids: [],
                questions_attributes: [
                  :id, :text, :flow, :position, :_update, :_create, :_destroy,
                  answer_ids: [],
                  answers_attributes: [:id, :text, :redirect_url, :question_id, :_create, :_destroy, :question
                  ]
                ],
                product_card_ids: [],
                product_cards_attributes: [:id, :title, :description, :image, :rate, :website_id, :_create, :_destroy],
                ad_ids: [],
                ads_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy],
                trackers_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy],
                advertisements_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy],
                esp_rules_attributes: [
                  :id, :delay_in_hours, :domain, :_destroy, esp_rules_lists_attributes: [:id, :list_id, :list_type, :_destroy]
                ],
                answer_ids: [],
                answers_attributes: [:id, :text, :redirect_url, :question_id, :_create, :_destroy, :question]

  filter :id
  filter :is_thankyou
  filter :is_checkboxes
  filter :is_phone_number
  filter :droplet_ip

  Struct.new('EspCollection', :name, :lists) unless defined?(Struct::EspCollection)
  esp_lists = [
    Struct::EspCollection.new('AweberList', AweberList.includes(:aweber_account)),
    Struct::EspCollection.new('AdopiaList', AdopiaList.includes(:adopia_account)),
    Struct::EspCollection.new('EliteGroup', EliteGroup.includes(:elite_account)),
    Struct::EspCollection.new('OngageList', OngageList.includes(:ongage_account)),
  ].freeze

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @s_couter_use_case = Formsite::STotalCountersUseCase.new
    end

    def scoped_collection
      super.includes :leadgen_rev_site_users
    end

    def create
      override_params
      super
    end

    def update
      override_params
      super
    end

    def override_params
      unless params.dig(:leadgen_rev_site, :esp_rules_attributes)
        params[:leadgen_rev_site][:esp_rules_attributes] = {}
      end
      params[:leadgen_rev_site][:esp_rules_attributes].each do |_, esp_rule|
        next unless esp_rule[:esp_rules_lists_attributes]
        esp_rule[:esp_rules_lists_attributes].each do |index, list|
          if list[:list_id].blank?
            esp_rule[:esp_rules_lists_attributes].delete(index)
          end
          list_id = list[:list_id]
          list[:list_id] = list_id.scan(/\d+/)[0].to_i
          list[:list_type] = list_id.scan(/[a-zA-Z]+/)[0]
        end
      end
    end
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
    actions
  end

  show do
    attributes_table do
      default_attribute_table_rows.each do |field|
        row field
      end

      panel 'ESP rules' do
        table_for leadgen_rev_site.esp_rules do
          column :delay_in_hours
          column :domain
          column 'Lists' do |l|

            l.esp_rules_lists.map do |erl|
              "#{erl.list_type}: #{erl.full_name}"
            end.join(', ')
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    tabs do
      tab 'SITE SETTINGS' do
        f.object.repo_url = f.object.repo_url.blank? ? 'git@github.com:flywithmemsl/bff-template.git' : f.object.repo_url
        f.inputs 'LeadgenRevSite' do

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

          f.has_many :esp_rules, allow_destroy: true, new_record: true, heading: 'ESP rules' do |ff|
            ff.semantic_errors
            ff.input :delay_in_hours
            ff.input :domain

            ff.has_many :esp_rules_lists, allow_destroy: true, new_record: true, heading: 'ESP lists' do |fff|
              fff.semantic_errors
              fff.input :list_id, label: 'ESP list', as: :select,
                        input_html: { class: 'esp-list-selector' },
                        collection: option_groups_from_collection_for_select(esp_lists, :lists, :name, :id_with_type, :full_name, fff.object&.list&.id_with_type)
              fff.input :list_type, label: false, input_html: { hidden: true, class: 'esp-list-type' }
            end
          end
        end
        f.actions
      end

      tab 'QUESTIONS' do
        render "questions"
        f.actions
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
        f.actions
      end
    end
  end

  action_item :setup, :only => :show do
    link_to setup_api_v1_leadgen_rev_sites_path(leadgen_rev_site), class: 'button builder_action', "data-type" => "json", remote: true do
      '<span>Setup Formsite</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end if leadgen_rev_site.droplet_ip.blank?
  end

  action_item :rebuild, :only => :show do
    link_to build_api_v1_leadgen_rev_sites_path(leadgen_rev_site), class: 'button builder_action', "data-type" => "json", remote: true do
      '<span>Rebuild Formsite</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end if !leadgen_rev_site.droplet_ip.blank?
  end
end
