namespace :suppression_lists do
  task autoremove_from_esp: :environment do
    emails = []
    lists = SuppressionList.where(autoremove_from_esp: true)
    lists.each do |list|
      CSV.foreach(list.file.file.file, headers: true) { |row| emails << row['Email'] }
    end

    EmailMarketerService::Aweber::BatchRemoveSubscribers.new(emails).call
    EmailMarketerService::Maropost::BatchRemoveContacts.new(emails).call
  end
end
