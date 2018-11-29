module EmailMarketerService
  module Bff
    class SendNow
      def initialize(mailgun_templates_schedule_id:)
        @mailgun_templates_schedule_id = mailgun_templates_schedule_id
      end

      def call
        client.send_now(@mailgun_templates_schedule_id)
      end

      private

      def client
        return @client if defined?(@client)
        @client = ::Bff::Client.new
      end
    end
  end
end
