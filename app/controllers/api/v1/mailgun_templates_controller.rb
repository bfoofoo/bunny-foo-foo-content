class Api::V1::MailgunTemplatesController < ApplicationController
  def schedule_sending
    @scheduled_job_id = EmailMarketerService::Mailgun::ScheduleSendingService.new(schedule_sending_params).schedule_sending

    render json: {
      status: 200,
      message: 'success',
      response: { scheduled_job_id: @scheduled_job_id }
    }
  end

  def delete_schedule
    EmailMarketerService::Mailgun::ScheduleSendingService.new(delete_schedule_params).delete_schedule

    render json: {
      status: 200,
      message: 'success'
    }
  end

  def send_now
    schedule = MailgunTemplatesSchedule.find(params[:mailgun_templates_schedule_id])
    Esp::SendEmailsToMailgunWorker.perform_async(schedule.mailgun_template_id, schedule.mailgun_list_id)

    render json: {
      status: 200,
      message: 'success'
    }
  end

  private

  def schedule_sending_params
    params.require(:schedule_sending).permit(:mailgun_template_id, :mailgun_list_id, :sending_time, :scheduled_job_id)
  end

  def delete_schedule_params
    params.require(:delete_schedule).permit(:scheduled_job_id)
  end
end
