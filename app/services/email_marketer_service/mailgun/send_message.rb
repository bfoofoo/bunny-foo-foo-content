module EmailMarketerService
  module Mailgun
    class SendMessage
      attr_reader :account

      def initialize(list:, mail:)
        @list = list
        @mail = mail
      end

      def call
        params = {
          from: "#{@mail.author.downcase}@#{domain}",
          to: @list.address,
          subject: @mail.subject,
          html: @mail.body
        }
        client.post("/#{domain}/messages", params)
      end

      private

      def domain
        @list.address.split('@').second
      end

      def client
        return @client if defined?(@client)
        @client = ::Mailgun::Client.new(@list.account.api_key)
      end
    end
  end
end
