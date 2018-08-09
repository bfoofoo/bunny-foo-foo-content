ActiveAdmin.register_page "Questions Affiliate Statistics" do
  menu parent: "Statistics"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @questions_statistics = Statistics::Questions::AStatistics.new(params)
    end
  end

  sidebar :help do
    render 'filters', stats_service: questions_statistics
  end

  content do
    render 'questions_stats', chart_data: questions_statistics.answers_counter_a_charts
  end
end 