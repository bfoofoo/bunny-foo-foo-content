module Esp
  class SendEmailsToMailgunWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'mailgun'

    def perform(mailgun_template_id, mailgun_list_id)
      mailgun_template = MailgunTemplate.find_by(id: mailgun_template_id)
      mailgun_list = MailgunList.find_by(id: mailgun_list_id)
      return unless mailgun_template && mailgun_list
      EmailMarketerService::Mailgun::SendMessage.new(list: mailgun_list, mail: mailgun_template).call
    end
  end
end
