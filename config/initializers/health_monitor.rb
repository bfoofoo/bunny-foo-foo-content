HealthMonitor.configure do |config|
  config.cache
  config.redis.configure do |redis_config|
    redis_config.connection = Redis.current
  end
  config.sidekiq.configure do |sidekiq_config|
    sidekiq_config.latency = 1.hour
  end

  config.error_callback = proc do |e, c|
    unless Rails.env == 'development'
      Discord::Notifier.message("[#{Rails.env}] Health check failed with #{e.class.demodulize}: #{e.message}")
      SlackNotifier.instance.post(
        {
          title: "[#{Rails.env}] Health check failed with #{e.class.demodulize}:",
          text: e.message,
          fallback: e.message,
          color: 'danger'
        }
      )
    end
  end
end