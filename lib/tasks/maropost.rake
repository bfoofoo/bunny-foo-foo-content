namespace :maropost do
  task collect_statistics: :environment do
    EmailMarketerService::Maropost::RetrieveBroadcastStats.new.call
  end
end
