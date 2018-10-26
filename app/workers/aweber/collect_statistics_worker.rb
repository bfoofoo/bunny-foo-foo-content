module Aweber
  class CollectStatisticsWorker
    include Sidekiq::Worker

    def perform
      EmailMarketerService::Aweber::RetrieveBroadcastStats.new.call
    end
  end
end
