Discord::Notifier.setup do |config|
  config.url = ENV['DISCORD_NOTIFICATION_WEBHOOK_URL']
end