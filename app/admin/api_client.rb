ActiveAdmin.register ApiClient do
  permit_params :name, :token,
                esp_rules_attributes: [
                  :id, :delay_in_hours, :domain, :affiliate, :_destroy, esp_rules_lists_attributes: [
                    :list_id, :list_type, :_destroy
                  ]
                ]

  action_item :generate_token, :only => :show do
    link_to("Generate API Token", generate_token_admin_api_client_path(id: params[:id]))
  end

  action_item :delete_token, :only => :show do
    link_to("Delete API Token", delete_token_admin_api_client_path(id: params[:id]))
  end

  member_action :generate_token, method: :get do
    ApiClient.find_by(id: params[:id]).update(token: SecureRandom.uuid.gsub(/\-/, ''))
    redirect_to :back
  end

  member_action :delete_token, method: :get do
    ApiClient.find_by(id: params[:id]).update(token: '')
    redirect_to :back
  end

  filter :id

  show do
    attributes_table do
      default_attribute_table_rows.each do |field|
        row field
      end

    end

    active_admin_comments
  end

  form do |f|
    f.inputs 'Api Client' do
      f.input :token
      f.input :name
    end

    f.inputs 'ESP rules' do
      f.has_many :esp_rules, allow_destroy: true, new_record: true, heading: false do |ff|
        ff.semantic_errors
        ff.input :delay_in_hours
        ff.input :domain
        ff.input :affiliate

        ff.has_many :esp_rules_lists, allow_destroy: true, new_record: true, heading: false do |fff|
          fff.semantic_errors
        end
      end
    end

    f.actions
  end
end
