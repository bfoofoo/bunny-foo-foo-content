ActiveAdmin.register_page "Aweber Table Stats" do
  menu parent: "Statistics"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @stats_service = Statistics::EmailMarketers::AweberTableStats.new(params)
    end
  end

  action_item :refresh do
    link_to 'Refresh statistics', api_v1_statistics_refresh_aweber_path, class: 'button builder_action', "data-type" => "json", remote: true
  end

  sidebar :help do
    render 'filters', stats_service: stats_service
  end

  content do
    render 'stats', table_data: stats_service.data
  end
end
