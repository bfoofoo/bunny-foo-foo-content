module Mixins
  module EmailMarketers
    module AweberAccounts
      attr_reader :aweber_account_id

      def aweber_account
        return @aweber_account if !@aweber_account.blank?
        @aweber_account = AweberAccount.find_by(id: aweber_account_id)
      end

      private

      def aweber_accounts
        return @aweber_accounts if !@aweber_accounts.blank?
        @aweber_accounts = AweberAccount.all
      end
    end
  end
end
