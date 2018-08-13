# ActiveAdmin.register_page "Questions Statistics1" do
#   menu parent: "Statistics"

#   controller do
#     before_action :initialize_data, only: :index

#     def initialize_data
#       @questions_statistics = Statistics::Questions::SStatistics.new(params)
#     end
#   end

#   sidebar :help do
#     # render 'filters', stats_service: questions_statistics
#   end

#   content do
#     tabs do
#       tab :active do
#       end
    
#       tab :inactive do
#       end
#     end
#     # render 'questions_stats', chart_data: questions_statistics.answers_counter_s_charts
#   end
# end