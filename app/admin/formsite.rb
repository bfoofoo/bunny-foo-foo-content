ActiveAdmin.register Formsite do
  permit_params :name, :description, :url,
                :droplet_id, :droplet_ip, :zone_id,
                :repo_url, :first_redirect_url, :final_redirect_url,
                :favicon_image, :logo_image, :background,
                :is_thankyou, :is_checkboxes,
                :left_side_content, :right_side_content,
                :first_question_code_snippet, :head_code_snippet,
                question_ids: [],
                questions_attributes: [
                    :id, :text, :position, :_update, :_create, :_destroy,
                    answer_ids: [],
                    answers_attributes: [:id, :text, :redirect_url, :question_id, :_create, :_destroy, :question
                  ]
                ],
                ad_ids: [],
                ads_attributes: [:id, :variety, :position, :widget, :google_id, :innerHTML, :_create, :_destroy],
                answer_ids: [],
                answers_attributes: [:id, :text, :redirect_url, :question_id, :_create, :_destroy, :question]

  index do
    column :id
    column :name
    column :is_thankyou
    column :is_checkboxes
    column :droplet_ip
    column "Total users" do |formsite|
      link_to "#{formsite.formsite_users.count}", "formsite_users?utf8=✓&q%5Bformsite_id_eq%5D=#{formsite.id}&commit=Filter&order=id_desc"
    end
    column "Passed useragent users" do |formsite|
      link_to "#{formsite.formsite_users.where(is_useragent_valid: true).count}", "formsite_users?utf8=✓&q%5Bformsite_id_eq%5D=#{formsite.id}&commit=Filter&order=id_desc"
    end
    column "Passed impressionwise test users" do |formsite|
      link_to "#{formsite.formsite_users.where(is_impressionwise_test_success: true).count}", "formsite_users?utf8=✓&q%5Bformsite_id_eq%5D=#{formsite.id}&commit=Filter&order=id_desc"
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :is_thankyou
      row :is_checkboxes
      row :favicon_image do |formsite|
        image_tag formsite.favicon_image.url unless formsite.favicon_image.url.nil?
      end
      row :logo_image do |formsite|
        image_tag formsite.logo_image.url unless formsite.logo_image.url.nil?
      end
      row :background do |formsite|
        image_tag formsite.background.url unless formsite.background.url.nil?
      end
      row :repo_url
      row :first_question_code_snippet
      row :head_code_snippet
      row :first_redirect_url
      row :final_redirect_url
      row "Total users" do |formsite|
        link_to "#{formsite.formsite_users.count}", "formsite_users?utf8=✓&q%5Bformsite_id_eq%5D=#{formsite.id}&commit=Filter&order=id_desc"
      end
      row "Passed useragent users" do |formsite|
        link_to "#{formsite.formsite_users.where(is_useragent_valid: true).count}", "formsite_users?utf8=✓&q%5Bformsite_id_eq%5D=#{formsite.id}&commit=Filter&order=id_desc"
      end
      row "Passed impressionwise test users" do |formsite|
        link_to "#{formsite.formsite_users.where(is_impressionwise_test_success: true).count}", "formsite_users?utf8=✓&q%5Bformsite_id_eq%5D=#{formsite.id}&commit=Filter&order=id_desc"
      end
      row :left_side_content, as: :wysihtml5, commands: 'all', blocks: 'all', height: 'huge'
      row :right_side_content, as: :wysihtml5, commands: 'all', blocks: 'all', height: 'huge'

    end
    active_admin_comments
  end

  form do |f|
    tabs do
      tab 'FORM SETTINGS' do
        f.object.repo_url = f.object.repo_url.blank? ? 'git@github.com:flywithmemsl/bff-forms.git' : f.object.repo_url
        f.inputs 'Formsite' do
          f.input :name
          f.input :is_thankyou
          f.input :is_checkboxes
          f.input :favicon_image
          f.input :logo_image
          f.input :background
          f.input :repo_url
          f.input :first_question_code_snippet
          f.input :head_code_snippet
          f.input :first_redirect_url
          f.input :final_redirect_url
          f.input :left_side_content, as: :wysihtml5, commands: 'all', blocks: 'all', height: 'huge'
          f.input :right_side_content, as: :wysihtml5, commands: 'all', blocks: 'all', height: 'huge'
        end
        f.actions
      end
      tab 'QUESTIONS' do
        render "questions"
        f.actions
      end
      tab 'ADS AND TRACKER' do
        AD_POSITIONS = ['tracker']
        AD_TYPES = ['text/javascript']

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
    link_to setup_api_v1_formsites_path(formsite), class: 'button builder_action', "data-type" => "json", remote: true do
      '<span>Setup Formsite</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end if formsite.droplet_ip.blank?
  end

  action_item :rebuild, :only => :show do
    link_to build_api_v1_formsites_path(formsite), class: 'button builder_action', "data-type" => "json", remote: true do
      '<span>Rebuild Formsite</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end if !formsite.droplet_ip.blank?
  end
end
