module Statistics
  module EmailMarketers
    class MaropostTableStats < BaseTableStats
      include Mixins::EmailMarketers::MaropostLists

      private

      def lead_class
        Leads::Maropost
      end

      def list_class
        MaropostList
      end

      def campaigns
        EmailMarketerCampaign.from_maropost.sent
      end
    end
  end
end
