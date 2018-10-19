ActiveAdmin.register ApiClient do
  esp_mapping_attributes = [:id, :source, :destination_id, :destination_type, :delay_in_hours, :tag, :domain, :_destroy]
  permit_params :name, :token,
                api_client_aweber_lists_attributes: esp_mapping_attributes,
                api_client_adopia_lists_attributes: esp_mapping_attributes,
                api_client_elite_groups_attributes: esp_mapping_attributes,
                api_client_ongage_lists_attributes: esp_mapping_attributes

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

      row 'Aweber Lists' do |api_client|
        api_client.api_client_aweber_lists.map do |acm|
          "#{acm.destination.name} (#{acm.delay_in_hours} hour delay, a: #{acm.tag})"
        end.join(', ')
      end


      row 'Adopia Lists' do |api_client|
        api_client.api_client_adopia_lists.map do |acm|
          "#{acm.destination.name} (#{acm.delay_in_hours} hour delay, a: #{acm.tag})"
        end.join(', ')
      end

      row 'Elite Groups' do |api_client|
        api_client.api_client_elite_groups.map do |acm|
          "#{acm.destination.name} (#{acm.delay_in_hours} hour delay, a: #{acm.tag})"
        end.join(', ')
      end

      row 'Ongage Lists' do |api_client|
        api_client.api_client_ongage_lists.map do |acm|
          "#{acm.destination.name} (#{acm.delay_in_hours} hour delay, a: #{acm.tag})"
        end.join(', ')
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs 'Api Client' do
      f.input :token
      f.input :name
    end

    render partial: 'esp_mapping_form', locals: { f: f, klass: 'AweberList', account: :aweber_account, relation: :api_client_aweber_lists }
    render partial: 'esp_mapping_form', locals: { f: f, klass: 'AdopiaList', account: :adopia_account, relation: :api_client_adopia_lists }
    render partial: 'esp_mapping_form', locals: { f: f, klass: 'EliteGroup', account: :elite_account, relation: :api_client_elite_groups }
    render partial: 'esp_mapping_form', locals: { f: f, klass: 'OngageList', account: :ongage_account, relation: :api_client_ongage_lists }

    f.actions
  end
end
