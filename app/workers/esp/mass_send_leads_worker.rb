module Esp
  class MassSendLeadsWorker
    include Sidekiq::Worker

    SENDER_CLASSES = %w(
      EmailMarketerService::Adopia::BatchSendLeads
      EmailMarketerService::Aweber::BatchSendLeads
      EmailMarketerService::Elite::BatchSendLeads
    ).freeze

    def perform
      emails = []
      CSV.foreach(file_path, headers: true) { |row| emails << row['Email'] }
      SENDER_CLASSES.each do |klass|
        klass.constantize.new(emails).call
      end
    end

    private

    def file_path
      Rails.root.join('tmp', "Leads_#{Date.current}")
    end
  end
end
