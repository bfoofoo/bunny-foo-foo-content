module Statistics
  module EmailMarketers
    class MaropostTableStats < BaseTableStats
      private

      def lead_class
        Leads::Maropost
      end

      def account_class
        MaropostAccount
      end

      def campaigns
        EmailMarketerCampaign.from_maropost.sent
      end
    end
  end
end
