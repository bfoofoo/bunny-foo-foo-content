module EmailMarketerService
  module Mailigen
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        lists.map do |list|
          # TODO switch to check by list_id later
          account.lists.find_or_create_by(
            name: list['name']
          ).update(list_id: list['web_id'], slug: list['id'])
        end
      end

      private

      def lists
        @lists ||= client.call :lists
      end

      def client
        return @client if defined?(@client)
        @client = ::Mailigen::Api.new(account.api_key)
      end
    end
  end
end
