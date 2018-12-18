module EmailMarketerService
  module Constantcontact
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        lists.map do |list|
          account.lists << ConstantcontactList.new(
            list_id: list.id,
            name: list.name
          )
        end
      end

      private

      def lists
        client.get_lists
      end

      def client
        return @client if defined?(@client)
          @client = ConstantContact::Api.new(account.api_key, account.access_token)          
      end
    end
   end
end
