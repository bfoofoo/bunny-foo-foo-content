module EmailMarketerService
  module Onepoint
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        lists.map do |list|
          account.lists.find_or_create_by(
            list_id: list['ListMasterID'],
            ).update(name: list['ListName'])
        end
      end

      private

      def lists
        client.lists.all['data']
      end

      def client
        return @client if defined?(@client)
        @client = ::Onepoint::Client.new(account.api_key)
      end
    end
  end
end
