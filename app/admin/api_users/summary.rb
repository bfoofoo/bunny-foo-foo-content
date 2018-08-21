ActiveAdmin.register_page "Summary" do
  menu parent: "API Users"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @api_clients = ApiClient.all.includes(:api_users)
    end
  end

  content do
    render 'summary', api_clients: @api_clients
  end

end