ActiveAdmin.register_page "Summary" do
  menu false
  menu parent: "API Users"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @api_clients = ApiClient.all
    end
  end

  content do
    render 'summary', api_clients: @api_clients
  end

end