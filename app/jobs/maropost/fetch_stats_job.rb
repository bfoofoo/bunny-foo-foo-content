module Maropost
  class FetchStatsJobs
    include SuckerPunch::Job

    def perform
      ActiveRecord::Base.connection_pool.with_connection do
        EmailMarketerService::Maropost::RetrieveBroadcastStats.new.call
      end
    end
  end
end
