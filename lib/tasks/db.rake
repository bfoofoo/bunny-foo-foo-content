namespace :db do
  def migration_hook
    STDOUT.puts($stdout.string)
    if Rails.env != 'development' && $stdout.string.size > 0
      Discord::Notifier.message("Running database migrations:\n#{$stdout.string}")
      SlackNotifier.instance.post(
        {
          title: "[#{Rails.env}] Running database migrations",
          text: "```#{$stdout.string}```",
          fallback: $stdout.string,
          mrkdwn: true,
          color: 'good'
        }
      )
    end
  ensure
    $stdout = @original_stdout
  end

  task :around_migration do
    @original_stdout = $stdout
    @line = StringIO.new
    $stdout = @line
    at_exit { migration_hook }
  end
end

Rake::Task['db:migrate'].enhance(['db:around_migration'])