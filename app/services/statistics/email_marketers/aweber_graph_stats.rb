module Statistics
  module EmailMarketers
    class AweberGraphStats < BaseGraphStats
      include Mixins::EmailMarketers::AweberLists

      private

      def list_element_name
        AweberList.model_name.element.to_sym
      end

      def list_table_name
        AweberList.table_name.to_sym
      end

      def lead_class
        Leads::Aweber
      end

    end
  end
end
