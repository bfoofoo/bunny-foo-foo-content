module EmailMarketerService
  module Adopia
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        lists.map do |list|
          account.lists << AdopiaList.new(
            list_id: list.id,
            name: list.name
          )
        end
      end

      private

      def lists
        client.pull_user_lists
      end

      def client
        return @client if defined?(@client)
        @client = ::Adopia::Client.new(account.api_key)
      end
    end
  end
end
