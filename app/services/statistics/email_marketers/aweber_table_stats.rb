module Statistics
  module EmailMarketers
    class AweberTableStats < BaseTableStats
      include Mixins::EmailMarketers::AweberLists

      private

      def lead_class
        Leads::Aweber
      end

      def list_class
        AweberList
      end

      def campaigns
        EmailMarketerCampaign.from_aweber.sent
      end
    end
  end
end
