ActiveAdmin.register Formsite do
  permit_params :name, :description, :url, :droplet_id, :droplet_ip, :zone_id, :repo_url, :first_redirect_url, :final_redirect_url, :favicon_image, :logo_image, :background, :is_thankyou, :left_side_content, question_ids: [], questions_attributes: [:id, :text, :_update,:_create]

  index do
    column :id
    column :name
    column :description
    column :is_thankyou
    column :droplet_id
    column :droplet_ip
    column :zone_id
    column :created_at
    actions
  end

  form do |f|
    f.object.repo_url = f.object.repo_url.blank? ? 'git@github.com:flywithmemsl/bff-forms.git' : f.object.repo_url
    f.inputs 'Formsite' do
      f.input :name
      f.input :description
      f.input :is_thankyou
      f.input :favicon_image
      f.input :logo_image
      f.input :background
      f.input :repo_url
      f.input :first_redirect_url
      f.input :final_redirect_url
      f.input :questions, as: :check_boxes, :collection => Question.all.map{ |q|  [q.text, q.id] }
      f.input :left_side_content, as: :wysihtml5, commands: 'all', blocks: 'all', height: 'huge'
    end
    f.actions
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
