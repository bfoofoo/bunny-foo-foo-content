ActiveAdmin.register EliteAccount do
  menu parent: 'ESP'

  config.filters = false

  permit_params :api_key, :sender

  member_action :refresh_lists, method: :post do
    account = EliteAccount.find(params[:id])
    EmailMarketerService::Elite::FetchGroups.new(account: account).call
    redirect_to admin_elite_account_path(account)
  end

  index do
    column :id
    column :sender
    column :api_key
    column "Groups count" do |account|
      account.elite_groups.count
    end

    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :sender
      row :api_key
      row :created_at
      panel "Groups" do
        table_for elite_account.groups do
          column :id
          column 'Group ID', :group_id
          column :name
        end
      end
    end
    active_admin_comments
  end

  action_item :refresh_lists, :only => [:show] do
    link_to refresh_lists_admin_elite_account_path(elite_account), class: 'button builder_action', method: :post do
      '<span>Refresh Elite Account</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end
  end
end
