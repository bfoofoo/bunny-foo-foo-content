class Api::V1::MessageSchedulesController < ApiController
  before_action :set_message_schedule, only: [:schedule_sending, :cancel, :send_now]

  def schedule_sending
    scheduled_job_id = Messages::SchedulingService.new(@message_schedule).schedule_sending

    render json: {
      status: 200,
      message: 'success',
      response: { scheduled_job_id: scheduled_job_id }
    }
  end

  def cancel
    Messages::SchedulingService.new(@message_schedule).cancel

    render json: {
      status: 200,
      message: 'success'
    }
  end

  def send_now
    Messages::MassSendWorker.perform_async(@message_schedule.id)

    render json: {
      status: 200,
      message: 'success'
    }
  end

  private

  def set_message_schedule
    @message_schedule = MessageSchedule.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }
  end
end
