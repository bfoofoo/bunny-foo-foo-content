class MigrateMailgunTemplates < ActiveRecord::Migration[5.0]
  def up
    MailgunTemplate.all.each do |mt|
      MessageTemplate.create(body: mt.body, subject: mt.subject, author: mt.author)
    end

    MailgunTemplatesSchedule.all.each do |mts|
      MessageSchedule.create(
        esp_list_id: mts.mailgun_list_id,
        eps_list_type: 'MailgunList',
        time: mts.sending_time,
        message_template_id: MessageTemplate.find_by(subject: mts.subject)&.id,
        scheduled_job_id: mts.scheduled_job_id
      )
    end
  end

  def down
    MessageSchedule.delete_all
    MessageTemplate.delete_all
  end
end
