module EmailMarketerService
  module Sparkpost
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        lists.map do |list|
          account.lists << SparkpostList.new(
            list_id: list['id'],
            name: list['name']
          )
        end
      end

      private

      def lists
        client.recipient_lists.list
      end

      def client
        return @client if defined?(@client)
        @client = SimpleSpark::Client.new(api_key: account.api_key)
      end
    end
  end
end
