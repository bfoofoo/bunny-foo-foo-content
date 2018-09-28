module Statistics
  module EmailMarketers
    class MaropostGraphStats < BaseGraphStats
      private

      def lead_class
        Leads::Maropost
      end

      def account_class
        MaropostAccount
      end
    end
  end
end
