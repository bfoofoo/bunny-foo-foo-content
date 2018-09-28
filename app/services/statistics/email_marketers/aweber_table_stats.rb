module Statistics
  module EmailMarketers
    class AweberTableStats < BaseTableStats
      include Mixins::EmailMarketers::AweberAccounts

      def initialize(params = {})
        super
        @aweber_account_id = params[:aweber_account_id]
      end

      private

      def lead_class
        Leads::Aweber
      end

      def campaigns
        query = EmailMarketerCampaign.from_aweber.sent
        query = query.where(account_id: aweber_account.account_id) if aweber_account
        query
      end

      def group_all_leads
        super
        @grouped_leads.each_with_object({}) do |(k, v), h| # iterate by date
          h[k] = v.group_by { |_, c| account_name(c['account_id']) }
        end
      end

      def account_name(account_id)
        aweber_accounts.find { |a| a.account_id == account_id }&.name
      end
    end
  end
end
