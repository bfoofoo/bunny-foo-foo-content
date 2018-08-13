namespace :aweber do  
  task migrate_subscribers: :environment do
    AweberInteractor::MigrateSubscribers.call({})
  end  
end
  