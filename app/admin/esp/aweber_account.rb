ActiveAdmin.register AweberAccount do
  menu parent: 'ESP'

  config.filters = false

  actions :all, except: [:new]
  permit_params :name, :account_id, :access_token, :secret_token

  controller do
    before_action :initialize_data, only: [:index, :show]

    def initialize_data
      @auth_service = EmailMarketerService::Aweber::AuthService.new(session: session)
    end
  end

  member_action :refresh_list, method: :post do
    account = AweberAccount.find(params[:id])
    AweberInteractor::RefreshAccountLists.call({
      access_token: account.access_token,
      access_token_secret: account.secret_token,
      account_id: account.id
    })
    redirect_to admin_aweber_account_path(account)
  end

  index do
    column :id
    column :name
    column :account_id
    column :access_token
    column :secret_token
    column "Lists count" do |account|
      account.aweber_lists.count
    end
    
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :account_id
      row :access_token
      row :secret_token
      row :created_at
      panel "Lists" do
        table_for aweber_account.aweber_lists do
          column :id
          column 'List ID', :list_id
          column :name
        end
      end
    end
    active_admin_comments
  end

  action_item :add_account, :only => [:index] do
    link_to auth_service.authorize_url, class: 'button builder_action' do
      '<span>Add Aweber Account</span> <span class="loader">
            <svg height="10px" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg" version="1.1">
              <path d="M 150,0 a 150,150 0 0,1 106.066,256.066 l -35.355,-35.355 a -100,-100 0 0,0 -70.711,-170.711 z" fill="#ffffff">
                <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 150 150" to="360 150 150" begin="0s" dur=".5s" fill="freeze" repeatCount="indefinite"></animateTransform>
              </path>
            </svg>
        </span>'.html_safe
    end 
  end

  action_item :add_account, :only => [:show] do
    link_to refresh_list_admin_aweber_account_path(aweber_account), class: 'button builder_action', method: :post do
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
