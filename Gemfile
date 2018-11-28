source 'https://rubygems.org'
ruby "2.4.1"
# git_source(:github) do |repo_name|
#   repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
#   "https://github.com/#{repo_name}.git"
# end

gem 'rails', '~> 5.0.2'
gem 'pg'
gem 'active_model_serializers', '~> 0.10.0'
gem 'rack-cors'
gem 'dotenv-rails'
gem 'net-ssh'
gem 'nissh'
gem "interactor", "~> 3.0"
gem 'draper'
gem "colorize"
gem 'activerecord-import'
gem 'rubyzip'
gem 'simple_enum'
gem 'httparty'
gem 'acts_as_paranoid', '~> 0.6.0'
gem 'capistrano-rails-console', require: false
gem 'savon', '~> 2.12.0'
gem 'rubyntlm'
gem 'mailgun-ruby', '~> 1.1', '>= 1.1.11'

# APIS
gem 'cloudflare'
gem 'droplet_kit'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '~> 2.6.1'
gem 'coffee-rails', '~> 4.2'
gem 'normalize-rails', '~> 4.1.1'
gem 'yaml_db'
gem 'kaminari'
gem 'autoprefixer-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem "flutie"
gem 'rest-client', '~> 2.0', '>= 2.0.2'
gem 'json'
gem 'bigdecimal'
gem 'health-monitor-rails'

# Webhooks
gem 'discord-notifier'
gem "slack-notifier"

#IMAGES
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'mini_magick'
gem "awesome_print", require: "ap"
gem 'devise'
gem "audited", "~> 4.7"

# Email marketing services
gem 'aweber', github: 'bfoofoo/AWeber-API-Ruby-Library'
gem 'maropost_api', github: 'bfoofoo/maropost_api'
gem 'simple_spark', github: 'bfoofoo/simple_spark'

# Background jobs
gem 'sidekiq'
gem 'sidekiq-cron', '~> 1.0', '>= 1.0.4'

gem 'rollbar'
gem 'swagger-docs'
gem 'swagger-blocks'

gem 'capistrano-dotenv-tasks', require: false
group :development, :test do
  gem 'spring'
  gem 'byebug', platform: :mri
  #deploy
  gem 'capistrano', '~> 3.7', '>= 3.7.1'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'capistrano-sidekiq'
  gem 'rspec-rails', '~> 3.5'

  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-nav'
end

group :test do
  gem 'factory_bot_rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker'
  gem 'database_cleaner'
end

group :development do
  gem 'spring-commands-rspec'
  gem 'rails-erd'
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'meta_request'
  gem "better_errors"
  gem "binding_of_caller"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'tzinfo-data'
