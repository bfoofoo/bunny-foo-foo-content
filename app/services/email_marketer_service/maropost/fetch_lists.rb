module EmailMarketerService
  module Maropost
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        lists.map do |list|
          account.lists << MaropostList.new(
            list_id: list.id,
            name: list.name
          )
        end
      end

      private

      def lists
        client.lists.all
      rescue MaropostApi::Errors
        []
      end

      def client
        return @client if defined?(@client)
        @client = MaropostApi::Client.new(auth_token: account.auth_token, account_number: account.account_id)
      end
    end
  end
end
