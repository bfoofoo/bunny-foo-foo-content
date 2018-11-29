module Bff
  class Client
    def initialize
      @request = Request.new
    end

    def schedule_sending(mailgun_template_id, mailgun_list_id, sending_time, scheduled_job_id)
      request = @request.post(
        'mailgun_templates/schedule_sending', 
        schedule_sending: {
          mailgun_template_id: mailgun_template_id,
          mailgun_list_id: mailgun_list_id,
          sending_time: sending_time,
          scheduled_job_id: scheduled_job_id
        }
      )
      
      response = Response.new(request).parse
      response[:scheduled_job_id]
    end

    def delete_schedule(scheduled_job_id)
      request = @request.post(
        'mailgun_templates/delete_schedule',
        delete_schedule: { scheduled_job_id: scheduled_job_id }
      )

      response = Response.new(request).parse
    end

    def send_now(mailgun_templates_schedule_id)
      request = @request.post(
        'mailgun_templates/send_now',
        mailgun_templates_schedule_id: mailgun_templates_schedule_id
      )
    end
  end
end
