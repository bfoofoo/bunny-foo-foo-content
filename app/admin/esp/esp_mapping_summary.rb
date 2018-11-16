ActiveAdmin.register_page "ESP Mappings Summary" do
    menu false
    menu parent: "ESP", priority: 0

    controller do
        before_action :initialize_data, only: :index
    
        def initialize_data
          @table_stats = {}
          @table_stats[:api_clients] = ApiClient.all.map do |ac|
            ac.esp_rules.map do |er|
                er.esp_rules_lists.map do |erl|
                    names = erl.list.full_name.split
                    { esp: erl.list_type, account: names.first, list: names.last, name: ac.name  }
                end
            end
          end.flatten
          @table_stats[:leadgen] = Formsite.all.map do |fs|
            fs.esp_rules.map do |er|
                er.esp_rules_lists.map do |erl|
                    names = erl.list.full_name.split
                    { esp: erl.list_type, account: names.first, list: names.last, name: fs.name  }
                end
            end
          end.flatten
          @table_stats[:leadgen_rev] = LeadgenRevSite.all.map do |lrs|
            lrs.esp_rules.map do |er|
                er.esp_rules_lists.map do |erl|
                    names = erl.list.full_name.split
                    { esp: erl.list_type, account: names.first, list: names.last, name: lrs.name  }
                end
            end
          end.flatten
        end 
      end

    content do
        render 'table', table_stats: table_stats  
    end

    
end