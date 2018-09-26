namespace :maropost do
  task collect_statistics: :environment do
    service = EmailMarketerService::Maropost::RetrieveBroadcastStats.new
    service.call
    puts service.result
  end
end
