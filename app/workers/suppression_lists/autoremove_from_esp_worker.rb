module SuppressionLists
  class AutoremoveFromEspWorker
    include Sidekiq::Worker

    def perform
      lists = SuppressionList.where(autoremove_from_esp: true)
      lists.each do |list|
        emails = []
        CSV.foreach(list.file.file.file, headers: true) { |row| emails << row['Email'] }

        EmailMarketerService::Aweber::BatchRemoveSubscribers.new(emails, list_ids: list.aweber_lists.pluck(:list_id)).call
        EmailMarketerService::Maropost::BatchRemoveContacts.new(emails, list_ids: list.maropost_lists.pluck(:list_id)).call
      end
    end
  end
end
