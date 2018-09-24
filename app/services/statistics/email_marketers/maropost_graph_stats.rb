module Statistics
  module EmailMarketers
    class MaropostGraphStats < BaseGraphStats
      include Mixins::EmailMarketers::MaropostLists

      private

      def list_element_name
        MaropostList.model_name.element.to_sym
      end

      def list_table_name
        MaropostList.table_name.to_sym
      end

      def lead_class
        Leads::Maropost
      end
    end
  end
end
