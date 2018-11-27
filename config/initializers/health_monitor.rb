HealthMonitor.configure do |config|
  config.cache
  config.redis.configure do |redis_config|
    redis_config.connection = Redis.current
  end
  config.sidekiq.configure do |sidekiq_config|
    sidekiq_config.latency = 1.hour
  end

  config.error_callback = proc do |e|
    Discord::Notifier.message("Health check failed with: #{e.message}") unless Rails.env == 'development'
  end
end