module SuppressionLists
  class AutoremoveFromEspWorker
    include Sidekiq::Worker

    def perform
      lists = SuppressionList.where(autoremove_from_esp: true)
      lists.each do |list|
        emails = []
        CSV.foreach(list.file.file.file, headers: true) { |row| emails << row['Email'] }

        # TODO remove subscribers here
      end
    end
  end
end
