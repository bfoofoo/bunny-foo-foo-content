namespace :aweber do
  task migrate_subscribers: :environment do
    AweberInteractor::MigrateSubscribers.call({})
  end

  desc 'Transfer aweber openers to maropost'
  task transfer_to_maropost: :environment do |_, args|
    log = ActiveSupport::Logger.new('log/aweber.log')

    # TODO make something convenient to set aweber list to maropost list mapping
    mapping = { 15 => 19}

    mapping.each do |source, destination|
      log.info("[#{Time.current.to_s}] Aweber (list # #{source}) to Maropost (list # #{destination}) transfering has started")
      service = EmailMarketerService::Aweber::TransferOpenersToMaropost.new(
        aweber_list: AweberList.find(source),
        maropost_list: MaropostList.find(destination),
        since: Date.new(2018, 8, 24))

      result = service.call
      log.info("[#{Time.current.to_s}] Finished transferring, #{result} leads have been sent.")
    end
  end
end
