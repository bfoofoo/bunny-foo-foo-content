namespace :aweber do
  task migrate_subscribers: :environment do
    AweberInteractor::MigrateSubscribers.call({})
  end

  desc 'Transfer aweber openers to maropost'
  task transfer_to_maropost: :environment do |_, args|
    Rails.logger = ActiveSupport::Logger.new('log/aweber.log')

    mappings = EmailMarketerMapping.where(source_type: 'AweberList', destination_type: 'MaropostList')

    mappings.each do |m|
      Rails.logger.info("[#{Time.current.to_s}] #{m.source_type} # #{m.source_id} to #{m.destination_type} # #{m.destination_id} transfering has started")
      service = EmailMarketerService::Aweber::TransferOpenersToMaropost.new(
        aweber_list: m.source,
        maropost_list: m.destination,
        since: m.start_date)

      service.call
      Rails.logger.info("[#{Time.current.to_s}] Finished transferring. Fetched leads: #{service.result[:fetched]}, sent leads: #{service.result[:sent]}.")
    end
  end
end
