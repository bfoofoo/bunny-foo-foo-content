module Statistics
    module EmailMarketers
      class MappingsSummary
        #attr_reader :start_date, :end_date

        def initialize(params = {})
        end

        def data
            {
                api_clients: api_clients_summary,
                leadgen: leadgen_summary,
                leadgen_rev: leadgen_rev_summary
            }
        end

        private

        def api_clients_summary
            ApiClient.all.map do |ac|
                ac.esp_rules.map do |er|
                    er.esp_rules_lists.map do |erl|
                        names = erl.list.full_name.split
                        { esp: erl.list_type, account: names.first, list: names.last, name: ac.name  }
                    end
                end
            end.flatten
        end

        def leadgen_summary
            Formsite.all.map do |fs|
                fs.esp_rules.map do |er|
                    er.esp_rules_lists.map do |erl|
                        names = erl.list.full_name.split
                        { esp: erl.list_type, account: names.first, list: names.last, name: fs.name  }
                    end
                end
            end.flatten
        end

        def leadgen_rev_summary
            LeadgenRevSite.all.map do |lrs|
                lrs.esp_rules.map do |er|
                    er.esp_rules_lists.map do |erl|
                        names = erl.list.full_name.split
                        { esp: erl.list_type, account: names.first, list: names.last, name: lrs.name  }
                    end
                end
            end.flatten
        end

      end
    end
end