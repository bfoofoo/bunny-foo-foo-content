ActiveAdmin.register_page "Jobs Statistics" do
  menu parent: "Statistics"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @jobs_statistics = Statistics::JobsStatistics.new(params)
    end
  end

  sidebar :help do
    render 'filters', stats_service: jobs_statistics
  end

  content do
    if !jobs_statistics.job_counts_hash.blank?
      render 'jobs_stats', jobs_statistics: jobs_statistics
    else
      div do
        h1 do
          "There is no results."
        end
      end
    end

  end
end