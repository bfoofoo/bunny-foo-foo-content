HealthMonitor.configure do |config|
  config.cache
  config.redis.configure do |redis_config|
    redis_config.connection = Redis.current
  end
  config.sidekiq.configure do |sidekiq_config|
    sidekiq_config.latency = 1.hour
  end
end