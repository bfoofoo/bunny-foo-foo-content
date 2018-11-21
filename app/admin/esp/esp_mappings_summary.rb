ActiveAdmin.register_page "ESP Mappings Summary" do
    menu false
    menu parent: "ESP", priority: 0

    controller do
        before_action :initialize_data, only: :index
    
        def initialize_data
          @table_stats = Statistics::EmailMarketers::MappingsSummary.new.data
        end 
      end

    content do
        render 'table', table_stats: table_stats  
    end

    
end