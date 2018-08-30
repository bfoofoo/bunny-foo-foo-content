ActiveAdmin.register_page "Leadgen Sites Statistics" do
  menu parent: "Statistics"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @formsites_statistics = Statistics::FormsitesStatistics.new(params)
    end
  end

  sidebar :help do
    render 'filters', stats_service: formsites_statistics
  end

  content do
    if !formsites_statistics.converted_counts_hash.blank?
      render 'formsites_stats', formsites_statistics: formsites_statistics
    else
      div do
        h1 do
          "There is no results."
        end
      end
    end

  end
end