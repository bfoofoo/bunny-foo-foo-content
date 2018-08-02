require 'capistrano/bundler'
set :application, "bffadmin"
set :repo_url, "git@github.com:flywithmemsl/bunny-foo-foo-content.git"

set :deploy_to, '/home/sammy/bffadmin'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"

namespace :bower do
  desc 'Install bower'
  task :install do
    on roles(:web) do
      within release_path do
        execute :rake, 'bower:install CI=true'
      end
    end
  end
end

before 'deploy:compile_assets', 'bower:install'
