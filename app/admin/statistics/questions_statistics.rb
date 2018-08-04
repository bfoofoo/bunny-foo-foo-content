ActiveAdmin.register_page "Questions Statistics" do
  menu parent: "Statistics"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @questions_statistics = Statistics::QuestionsStatistics.new(params)
    end
  end

  sidebar :help do
    render 'filters'
  end

  content do
    render 'questions_stats', chart_data: questions_statistics.answers_counter_s_charts
  end
end