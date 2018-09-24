ActiveAdmin.register_page "Aweber Table Stats" do
  menu parent: "Statistics"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @stats_service = Statistics::EmailMarketers::AweberTableStats.new(params)
    end
  end

  sidebar :help do
    render 'filters', stats_service: stats_service
  end

  content do
    render 'stats', table_data: stats_service.data
  end
end
