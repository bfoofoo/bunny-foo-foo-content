module EmailMarketerService
  module Mailgun
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        lists.map do |list|
          account.lists << MailgunList.new(
            address: list['address'],
            name: list['name']
          )
        end
      end

      private

      def lists
        response = client.get('/lists')
        JSON.parse(response.body)&.[]('items').to_a
      rescue JSON::ParserError
        []
      end

      def client
        return @client if defined?(@client)
        @client = ::Mailgun::Client.new(account.api_key)
      end
    end
  end
end
