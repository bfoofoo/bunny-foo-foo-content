module Esp
  class SendEmailsToMailgunWorker
    include Sidekiq::Worker

    def perform
      MailgunList.all.each do |list|
        begin
          EmailMarketerService::Mailgun::SendMessage.new(list: list, mail: list.mailgun_templates.sample).call unless list.mailgun_templates.empty?
        rescue
          next
        end
      end
    end
  end
end
