require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BffAdmin
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Central Time (US & Canada)'
    config.active_record.default_timezone = :local

    config.middleware.use Rack::Deflater
    config.assets.paths << "#{Rails.root}/app/assets/videos"
    config.autoload_paths << Rails.root.join('app', 'use_cases')
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.i18n.default_locale = :en

    config.log_tags = [
      :request_id,
      ->(req) {
        session_key = (Rails.application.config.session_options || {})[:key]
        session_data = req.cookie_jar.encrypted[session_key] || {}
        "user_email: #{session_data["user_email"]} user_ip: #{req.env['REMOTE_ADDR']}"
      }
    ]
  end
end
