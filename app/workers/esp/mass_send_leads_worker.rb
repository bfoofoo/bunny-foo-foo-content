module Esp
  class MassSendLeadsWorker
    include Sidekiq::Worker

    def perform(provider = nil)
      emails = []
      CSV.foreach(file_path, headers: true) { |row| emails << row['email'] }
      service = sender_class(provider).new(emails)
      service.call
      puts "#{service.processed_emails.count} emails processed."
    end

    private

    def file_path
      Rails.root.join('tmp', 'leads', "leads_#{Date.current}.csv")
    end

    def sender_class(provider)
      "EmailMarketerService::#{provider}::BatchSendLeads".constantize
    end
  end
end
