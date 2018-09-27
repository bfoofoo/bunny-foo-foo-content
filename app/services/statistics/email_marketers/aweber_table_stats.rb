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

      def group_all_leads
        super
        @grouped_leads.each_with_object({}) do |(k, v), h| # iterate by date
          h[k] = v.group_by { |_, c| account_name(c['account_id']) }
          p h[k].keys
          h[k]
        end
      end

      def account_name(account_id)
        aweber_accounts.find { |a| a.account_id == account_id }&.name
      end

      def aweber_accounts
        @aweber_accounts ||= AweberAccount.all.to_a
      end
    end
  end
end
