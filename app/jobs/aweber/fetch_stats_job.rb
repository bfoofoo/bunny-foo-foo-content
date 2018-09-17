module Aweber
  class FetchStatsJob
    include SuckerPunch::Job

    def perform
      ActiveRecord::Base.connection_pool.with_connection do
        EmailMarketerService::Aweber::RetrieveBroadcastStats.new.call
      end
    end
  end
end
