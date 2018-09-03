ActiveAdmin.register_page "Leadgensites Graph Stats" do
  menu parent: "Statistics"
  
  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @formsites = Formsite.all
      @stats_service = Statistics::ConvertedAffiliatesStatistics.new(params)
    end
  end

  sidebar :help do
    render 'filters', stats_service: stats_service, formsites: formsites
  end

  content do
    render 'questions_stats', chart_data: stats_service.chart_data
  end
end