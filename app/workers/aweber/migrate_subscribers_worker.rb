module Aweber
  class MigrateSubscribersWorker
    include Sidekiq::Worker

    def perform
      AweberInteractor::MigrateSubscribers.call
    end
  end
end
