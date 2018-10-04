ActiveAdmin.register_page "Questions Table Statistics" do
  menu parent: "Statistics"

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
    render 'questions_table_stats', table_stats: questions_statistics.table_stats
  end
end
