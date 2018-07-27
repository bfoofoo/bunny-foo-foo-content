ActiveAdmin.register_page "Formsites Statistics" do
  menu parent: "Statistics"

  controller do
    before_action :initialize_data, only: :index

    def initialize_data
      @sormsites_statistics = Statistics::FormsitesStatistics.new()
    end
  end

  content do
    table class: "index_table index" do
      thead do
        tr do
          sormsites_statistics.count_by_s_description.keys.each do |key|
            th class: "col col-id" do
              "#{key} Users Count"
            end
          end
        end
      end
      tbody do
        sormsites_statistics.count_by_s_description.keys.each do |key|
          td class: "col col-id" do
            sormsites_statistics.count_by_s_description[key]
          end
        end
      end
    end
  end
end