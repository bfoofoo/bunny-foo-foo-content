ActiveAdmin.register MaropostAccount do
  permit_params :name, :account_id, :auth_token

  menu false

  member_action :refresh_list, method: :post do
    account = MaropostAccount.find(params[:id])
    MaropostInteractor::RefreshAccountLists.call(account_id: account.id)
    redirect_to admin_maropost_account_path(account)
  end

  index do
    column :id
    column :name
    column :account_id
    column :auth_token
    column "Lists count" do |account|
      account.lists.count
    end

    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :account_id
      row :auth_token
      row :created_at
      panel "Lists" do
        table_for maropost_account.lists do
          column :id
          column 'List ID', :list_id
          column :name
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Maropost Account' do
      f.input :name
      f.input :account_id, label: 'Account ID'
      f.input :auth_token, input_html: { rows: 2 }
    end

    f.actions
  end


  action_item :add_account, :only => [:show] do
    link_to refresh_list_admin_maropost_account_path(maropost_account), class: 'button builder_action', method: :post do
      '<span>Refresh Aweber Account</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end
  end
end
