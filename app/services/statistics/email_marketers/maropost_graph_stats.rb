module Statistics
  module EmailMarketers
    class MaropostGraphStats < BaseGraphStats
      include Mixins::EmailMarketers::MaropostLists

      def initialize(params = {})
        super
        @maropost_list_id = params[:maropost_list_id]
      end

      private

      def list
        maropost_list
      end

      def list_id
        maropost_list_id
      end

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
