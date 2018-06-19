# Load DSL and set up stages
require "capistrano/setup"

require "capistrano/deploy"
require "capistrano/scm/git"
require 'capistrano/rails'
# require 'capistrano/rails/migrations'
require 'capistrano/passenger'
require 'capistrano/bundler'
require 'capistrano/rbenv'
set :rbenv_type, :user
set :rbenv_ruby, '2.2.6'
set :rbenv_path, '/home/deploy/.rbenv/'
install_plugin Capistrano::SCM::Git


Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
