# Load DSL and set up stages
require "capistrano/setup"

require "capistrano/deploy"
require "capistrano/scm/git"
require 'capistrano/rails'
# require 'capistrano/rails/migrations'
require 'capistrano/dotenv'
require 'capistrano/dotenv/tasks'
require 'capistrano/passenger'
require 'capistrano/bundler'
require 'capistrano/rbenv'
set :rbenv_type, :user
set :rbenv_ruby, '2.4.1'
set :rbenv_path, '/home/sammy/.rbenv/'
install_plugin Capistrano::SCM::Git


Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
