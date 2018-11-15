ActiveAdmin.register SparkpostAccount do
  menu parent: 'ESP'

  config.filters = false

  permit_params :api_key, :username, :account_id

  member_action :refresh_lists, method: :post do
    account = SparkpostAccount.find(params[:id])
    EmailMarketerService::Sparkpost::FetchLists.new(account: account).call
    redirect_to admin_sparkpost_account_path(account)
  end

  index do
    column :id
    column :account_id
    column :username
    column :api_key
    column 'Lists count' do |account|
      account.lists.count
    end

    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :account_id
      row :username
      row :api_key
      panel 'Lists' do
        table_for sparkpost_account.lists do
          column :id
          column 'List ID', :list_id
          column :name
        end
      end
    end
    active_admin_comments
  end


  action_item :refresh_lists, :only => [:show] do
    link_to refresh_lists_admin_sparkpost_account_path(sparkpost_account), class: 'button builder_action', method: :post do
      '<span>Refresh Sparkpost Account</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end
  end
end
