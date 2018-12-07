module EmailMarketerService
  module Netatlantic
    class FetchLists < EmailMarketerService::Netatlantic::BaseService
      attr_reader :account

      def initialize(account:nil)
        @account = account
      end

      def call
        HTTParty.get("#{API_PATH}/lists.php?account=#{account.account_name}")
      end
    end
  end
end