module EmailMarketerService
  module Bff
    class ScheduleSending
      def initialize(mailgun_template_id:, mailgun_list_id:, sending_time:, scheduled_job_id:)
        @mailgun_template_id = mailgun_template_id
        @mailgun_list_id = mailgun_list_id
        @sending_time = sending_time
        @scheduled_job_id = scheduled_job_id
      end

      def call
        client.schedule_sending(@mailgun_template_id, @mailgun_list_id, @sending_time, @scheduled_job_id)
      end

      private

      def client
        return @client if defined?(@client)
        @client = ::Bff::Client.new
      end
    end
  end
end
