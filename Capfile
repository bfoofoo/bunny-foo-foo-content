# Load DSL and set up stages
require "capistrano/setup"

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
set :rbenv_ruby, '2.5.3'
set :rbenv_path, '/home/sammy/.rbenv/'
install_plugin Capistrano::SCM::Git


Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
