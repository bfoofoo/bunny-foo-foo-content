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
set :local_user, -> { `git config user.name`.chomp }

Dotenv.load
set :slack_webhook_url, 'https://hooks.slack.com/services/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'
set :discord_webhook_url, 'https://discordapp.com/api/webhooks/516937679745843200/acb3ipQpHsN1CdrTvj_eqIgKw8-XHxVEnYqSJvluMptNYK2c1QDvHEP-bjaIe5mwyQe9'

install_plugin Capistrano::SCM::Git


Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
