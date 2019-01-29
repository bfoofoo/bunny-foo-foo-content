module EmailMarketerService
  module Mailigen
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        lists.each{  |list|
          account.lists.find_or_create_by(
            list_id: list['web_id'],
          ).update(name: list['name'],campaign_id: list['id'])
        }
      end

      private

      def lists
        client.call :lists
      end

      def client
        return @client if defined?(@client)
        @client = ::Mailigen::Api.new(account.api_key)
      end
    end
  end
end
