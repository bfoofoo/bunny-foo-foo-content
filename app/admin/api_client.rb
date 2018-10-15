ActiveAdmin.register ApiClient do
  permit_params :name, :token,
                api_client_aweber_lists_attributes: [:id, :source, :destination_id, :destination_type, :delay_in_hours, :tag, :_destroy],
                api_client_adopia_lists_attributes: [:id, :source, :destination_id, :destination_type, :delay_in_hours, :tag, :_destroy]

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
    end

    active_admin_comments
  end

  form do |f|
    f.inputs 'Api Client' do
      f.input :token
      f.input :name
    end

    f.inputs 'Aweber Lists' do
      f.has_many :api_client_aweber_lists, allow_destroy: true, new_record: true, heading: false do |ff|
        ff.semantic_errors
        ff.input :destination_type, label: false, input_html: { hidden: true, value: 'AweberList' }
        ff.input :destination_id, :label => 'List', :as => :select, collection: AweberList.includes(:aweber_account).all
        ff.input :tag, label: 'Affiliate'
        ff.input :delay_in_hours
      end
    end

    f.inputs 'Adopia Lists' do
      f.has_many :api_client_adopia_lists, allow_destroy: true, new_record: true, heading: false do |ff|
        ff.semantic_errors
        ff.input :destination_type, label: false, input_html: { hidden: true, value: 'AdopiaList' }
        ff.input :destination_id, :label => 'List', :as => :select, collection: AdopiaList.includes(:adopia_account).all
        ff.input :tag, label: 'Affiliate'
        ff.input :delay_in_hours
      end
    end

    f.actions
  end
end
