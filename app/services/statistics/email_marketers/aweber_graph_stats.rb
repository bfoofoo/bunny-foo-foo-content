module Statistics
  module EmailMarketers
    class AweberGraphStats < BaseGraphStats
      include Mixins::EmailMarketers::AweberLists

      def initialize(params = {})
        super
        @aweber_list_id = params[:aweber_list_id]
      end

      private

      def list
        aweber_list
      end

      def list_id
        aweber_list_id
      end

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
