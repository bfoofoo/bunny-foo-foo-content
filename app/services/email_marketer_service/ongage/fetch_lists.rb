module EmailMarketerService
  module Ongage
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        lists.map do |list|
          account.lists.find_or_create_by(
            list_id: list[:id],
            ).update(name: list[:name])
        end
      end

      private

      def lists
        client.lists.all(type: 'sending')
      end

      def client
        return @client if defined?(@client)
        @client = ::Ongage::Client.new(account.username, account.password, account.account_code)
      end
    end
  end
end
