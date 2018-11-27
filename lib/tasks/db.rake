namespace :db do
  def migration_hook
    STDOUT.puts($stdout.string)
    Discord::Notifier.message("Running database migrations:\n#{$stdout.string}") unless Rails.env == 'development'
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