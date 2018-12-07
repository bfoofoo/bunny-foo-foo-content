module EmailMarketerService
  module Mailgun
    class ScheduleSendingService
      def initialize(params)
        @mailgun_template_id = params[:mailgun_template_id]
        @mailgun_list_id = params[:mailgun_list_id]
        @sending_time = params[:sending_time].to_datetime if params[:sending_time].present?
        @scheduled_job_id = params[:scheduled_job_id]
      end

      def schedule_sending
        cancel_job(@scheduled_job_id) if @scheduled_job_id.present?

        Esp::SendEmailsToMailgunWorker.perform_at(
          @sending_time,
          @mailgun_template_id,
          @mailgun_list_id
        )
      end

      def delete_schedule
        cancel_job(@scheduled_job_id)
      end

      def send_now
        Esp::SendEmailsToMailgunWorker.perform_async(@mailgun_template_id, @mailgun_list_id)
      end

      private

      def cancel_job(scheduled_job_id)
        ss = Sidekiq::ScheduledSet.new
        job = ss.find { |job_id| scheduled_job_id }
        job.delete if job.present?
      end
    end
  end
end
