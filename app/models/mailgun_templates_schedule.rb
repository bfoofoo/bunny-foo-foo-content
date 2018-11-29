class MailgunTemplatesSchedule < ApplicationRecord
  belongs_to :mailgun_template
  belongs_to :mailgun_list

  validates :sending_time, presence: true

  before_save :schedule_sending

  before_destroy :delete_schedule

  private

  def schedule_sending
    service = EmailMarketerService::Bff::ScheduleSending.new(
      mailgun_template_id: mailgun_template_id,
      mailgun_list_id: mailgun_list_id,
      sending_time: sending_time,
      scheduled_job_id: scheduled_job_id
    )

    self.scheduled_job_id = service.call
  end

  def delete_schedule
    EmailMarketerService::Bff::DeleteSchedule.new(scheduled_job_id: scheduled_job_id).call
  end
end
