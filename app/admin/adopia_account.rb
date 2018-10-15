ActiveAdmin.register AdopiaAccount do
  config.filters = false

  permit_params :api_key, :name

  member_action :refresh_lists, method: :post do
    account = AdopiaAccount.find(params[:id])
    AdopiaInteractor::RefreshAccountLists.call(account_id: account.id)
    redirect_to admin_adopia_account_path(account)
  end

  show do
    attributes_table do
      row :id
      row :name
      row :api_key
      row :created_at
      panel "Lists" do
        table_for adopia_account.lists do
          column :id
          column 'List ID', :list_id
          column :name
        end
      end
    end
    active_admin_comments
  end

  action_item :refresh_lists, :only => [:show] do
    link_to refresh_lists_admin_adopia_account_path(adopia_account), class: 'button builder_action', method: :post do
      '<span>Refresh Adopia Account</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end
  end
end
