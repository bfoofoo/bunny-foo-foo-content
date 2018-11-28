# Load DSL and set up stages
require "capistrano/setup"
require 'dotenv/load'
require "capistrano/deploy"
require "capistrano/scm/git"
require 'capistrano/rails'
require 'capistrano/rails/console'
require 'capistrano/dotenv/tasks'
require 'capistrano/passenger'
require 'capistrano/bundler'
require 'capistrano/rbenv'
require 'capistrano/sidekiq'
require 'slackistrano/capistrano'
set :rbenv_type, :user
set :rbenv_ruby, '2.4.1'
set :rbenv_path, '/home/sammy/.rbenv/'

Dotenv.load
set :slack_webhook_url, ENV['SLACK_WEBHOOK_URL']
set :discord_webhook_url, ENV['DISCORD_NOTIFICATION_WEBHOOK_URL']

install_plugin Capistrano::SCM::Git


Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
