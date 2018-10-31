ActiveAdmin.register NetatlanticAccount do
  menu parent: 'ESP'

  config.filters = false
  permit_params :name, :sender_name, :sender

  member_action :refresh_list, method: :post do
    account = NetatlanticAccount.find(params[:id])
    NetatlanticInteractor::RefreshAccountLists.call({
      account_id: account.id
    })
    redirect_to admin_netatlantic_account_path(account)
  end

  index do
    column :id
    column :sender
    column :sender_name
    column "Lists count" do |account|
      account.netatlantic_lists.count
    end
    
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :sender
      row :sender_name
      panel "Lists" do
        table_for netatlantic_account.netatlantic_lists do
          column :id
          column 'List ID', :list_id
          column :name
        end
      end
    end
  end

  action_item :add_account, :only => [:show] do
    link_to refresh_list_admin_netatlantic_account_path(netatlantic_account), class: 'button builder_action', method: :post do
      '<span>Refresh Netatlantic Account</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end 
  end
end