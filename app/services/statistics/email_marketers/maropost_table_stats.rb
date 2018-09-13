module Statistics
  module EmailMarketers
    class MaropostTableStats < BaseTableStats
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

      def lead_class
        Leads::Maropost
      end

      def list_class
        MaropostList
      end


    end
  end
end
