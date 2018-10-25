ActiveAdmin.register ApiClient do
  permit_params :name, :token, esp_rules_attributes: [
                  :id, :delay_in_hours, :domain, :affiliate, :_destroy, esp_rules_lists_attributes: [:id, :list_id, :list_type, :_destroy]
                ]

  Struct.new('EspCollection', :name, :lists) unless defined?(Struct::EspCollection)
  esp_lists = [
    Struct::EspCollection.new('AweberList', AweberList.includes(:aweber_account)),
    Struct::EspCollection.new('AdopiaList', AdopiaList.includes(:adopia_account)),
    Struct::EspCollection.new('EliteGroup', EliteGroup.includes(:elite_account)),
    Struct::EspCollection.new('OngageList', OngageList.includes(:ongage_account)),
  ].freeze

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

  controller do
    def create
      override_params
      super
    end

    def update
      override_params
      super
    end

    def override_params
      unless params.dig(:api_client, :esp_rules_attributes)
        params[:api_client][:esp_rules_attributes] = {}
      end
      params[:api_client][:esp_rules_attributes].each do |_, esp_rule|
        next if esp_rule[:esp_rules_lists_attributes].to_a.empty?
        esp_rule[:esp_rules_lists_attributes].each do |_, list|
          list_id = list[:list_id]
          list[:list_id] = list_id.scan(/\d+/)[0].to_i
          list[:list_type] = list_id.scan(/[a-zA-Z]+/)[0]
        end
      end
    end
  end

  show do
    attributes_table do
      default_attribute_table_rows.each do |field|
        row field
      end

      panel 'ESP rules' do
        table_for api_client.esp_rules do
          column :delay_in_hours
          column :domain
          column :affiliate
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
    f.inputs 'Api Client' do
      f.input :token
      f.input :name

      f.has_many :esp_rules, allow_destroy: true, new_record: true, heading: 'ESP rules' do |ff|
        ff.semantic_errors
        ff.input :delay_in_hours
        ff.input :domain
        ff.input :affiliate

        ff.has_many :esp_rules_lists, allow_destroy: true, new_record: true, heading: 'ESP lists' do |fff|
          fff.semantic_errors
          fff.input :list_id, label: 'ESP list', as: :select,
                    input_html: { class: 'esp-list-selector' },
                    collection: option_groups_from_collection_for_select(esp_lists, :lists, :name, :id_with_type, :full_name, fff.object&.list&.id_with_type)
        end
      end
    end

    f.actions
  end
end
