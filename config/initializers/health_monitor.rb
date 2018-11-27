HealthMonitor.configure do |config|
  config.cache
  config.redis
  config.sidekiq.configure do |sidekiq_config|
    sidekiq_config.latency = 1.hour
  end
end