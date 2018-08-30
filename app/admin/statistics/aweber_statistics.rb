ActiveAdmin.register_page "Aweber Statistics" do
  menu parent: "Statistics"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @stats_service = Statistics::EmailMarketers::Aweber.new
    end
  end

  sidebar :help do
    render 'filters', stats_service: stats_service
  end
end
