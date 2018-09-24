ActiveAdmin.register_page "Aweber Graph Stats" do
  menu parent: "Statistics"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @stats_service = Statistics::EmailMarketers::AweberGraphStats.new(params)
    end
  end

  sidebar :help do
    render 'filters', stats_service: stats_service
  end

  content do
    render 'stats', chart_data: stats_service.chart_data
  end
end
