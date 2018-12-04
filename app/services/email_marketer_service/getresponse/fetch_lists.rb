module EmailMarketerService
  module Getresponse
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        lists.map do |list|
          account.lists << GetresponseList.new(campaign_id: list["campaignId"], name: list["name"])
        end
      end

      private

      def lists
        client.lists
      end

      def client
        return @client if defined?(@client)
        @client = EmailMarketerService::Getresponse::ApiWrapperService.new(account: account)
      end
    end
  end
end
