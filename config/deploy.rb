require 'capistrano/bundler'
require 'resolv-replace'

set :application, "bff_admin"
set :repo_url, "git@github.com:flywithmemsl/bunny-foo-foo-content.git"

set :deploy_to, '/home/sammy/bffadmin'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails sidekiq sidekiqctl}
set :linked_files, %w{.env}
set :slackistrano, {
  channel: "#adsense-pulse",
  webhook: ENV['SLACK_WEBHOOK_URL']
}
append :linked_files, "config/database.yml", "config/secrets.yml"
# TODO remove 'tmp/leads' after all leads are sent
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads", "public/swagger", "tmp/leads"

namespace :rails do
  desc "Run the console on a remote server."
  task :logs do
    on roles(:app) do |h|
      execute_interactively "tail -f #{fetch(:deploy_to)}/current/log/#{fetch(:rails_env)}.log", h.user
    end
  end

  def execute_interactively(command, user)
    info "Connecting with #{user}@#{host}"
    cmd = "ssh #{user}@#{host} -p 22 -t 'cd #{fetch(:deploy_to)}/current && #{command}'"
    exec cmd
  end
end
