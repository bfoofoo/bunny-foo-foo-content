require 'capistrano/bundler'
require 'discord_notifier'

set :application, "bff_admin"
set :repo_url, "git@github.com:flywithmemsl/bunny-foo-foo-content.git"

set :deploy_to, '/home/sammy/bffadmin'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails sidekiq sidekiqctl}
set :linked_files, %w{.env}
set :slackistrano, {
  channel: "#adsense-pulse",
  webhook: fetch(:slack_webhook_url)
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

namespace :discord do
  desc 'Notify when deploy started'
  task :started do
    Discord::Notifier.message("Started deploying branch #{fetch(:branch)} of #{fetch(:application)} to #{fetch(:rails_env)}", url: fetch(:discord_webhook_url))
  end

  desc 'Notify when app published'
  task :published do
    Discord::Notifier.message("Finished deploying branch #{fetch(:branch)} of #{fetch(:application)} to #{fetch(:rails_env)}", url: fetch(:discord_webhook_url))
  end
end

after 'deploy:finishing', 'discord:published'
after 'deploy:updating', 'discord:started'
