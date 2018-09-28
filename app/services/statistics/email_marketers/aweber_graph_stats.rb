module Statistics
  module EmailMarketers
    class AweberGraphStats < BaseGraphStats
      include Mixins::EmailMarketers::AweberAccounts

      def initialize(params = {})
        super
        @aweber_account_id = params[:aweber_account_id]
      end

      private

      def lead_class
        Leads::Aweber
      end

      def account_class
        AweberAccount
      end

      def account_id
        aweber_account_id
      end

    end
  end
end
