module Messages
  class SchedulingService
    attr_reader :message_schedule

    def initialize(message_schedule)
      @message_schedule = message_schedule
    end

    def schedule_sending
      cancel_job(message_schedule.scheduled_job_id) if message_schedule.scheduled_job_id.present?
      Messages::MassSendWorker.perform_at(
        message_schedule.time,
        message_schedule.id
      )
    end

    def cancel
      cancel_job(message_schedule.scheduled_job_id)
    end

    def send_now
      Messages::MassSendWorker.perform_async(message_schedule.id)
    end

    private

    def cancel_job(scheduled_job_id)
      ss = Sidekiq::ScheduledSet.new
      job = ss.find_job(scheduled_job_id)
      job.delete if job.present?
    end
  end
end
