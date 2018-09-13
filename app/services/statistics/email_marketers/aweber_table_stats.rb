module Statistics
  module EmailMarketers
    class AweberTableStats < BaseTableStats
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

      def lead_class
        Leads::Aweber
      end

      def list_class
        AweberList
      end
    end
  end
end
