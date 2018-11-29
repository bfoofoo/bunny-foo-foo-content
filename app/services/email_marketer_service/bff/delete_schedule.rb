module EmailMarketerService
  module Bff
    class DeleteSchedule
      def initialize(scheduled_job_id:)
        @scheduled_job_id = scheduled_job_id
      end

      def call
        client.delete_schedule(@scheduled_job_id)
      end

      private

      def client
        return @client if defined?(@client)
        @client = ::Bff::Client.new
      end
    end
  end
end
