ActiveAdmin.register_page "Questions Total Statistics" do
  menu false

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @questions_statistics = Statistics::Questions::TotalStatistics.new(params)
    end
  end

  sidebar :help do
    render 'filters', stats_service: questions_statistics
  end

  content do
    render 'questions_stats', chart_data: questions_statistics.answers_counter_s_charts
  end
end