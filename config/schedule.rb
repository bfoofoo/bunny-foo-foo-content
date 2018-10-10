# TODO completely replace with Sidekiq::Cron
job_type :rake_verbose, "cd :path && :environment_variable=:environment :bundle_command rake :task :output"

every 1.day do
  rake "aweber:migrate_subscribers"
end


every 1.day do
  rake "suppression_lists:autoremove_from_esp"
end

every [:monday, :thursday] do
  rake "aweber:collect_statistics"
end
