ActiveAdmin.register_page "Leadgen Sites Statistics" do
  menu parent: "Statistics"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @sormsites_statistics = Statistics::FormsitesStatistics.new(params)
      @sormsites_statistics.count_by_s
    end
  end

  sidebar :help do
    render 'filters'
  end

  content do
    if !sormsites_statistics.count_by_s.blank?      
      render 'formsites_stats', chart_data: sormsites_statistics.count_by_s_charts(), sormsites_statistics: sormsites_statistics
    else
      div do
        h1 do
          "There is no results."
        end
      end
    end

  end
end