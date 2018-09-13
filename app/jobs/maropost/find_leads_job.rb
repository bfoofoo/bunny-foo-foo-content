module Maropost
  class FindLeadsJob
    include SuckerPunch::Job

    def perform
      ActiveRecord::Base.connection_pool.with_connection do
        EmailMarketerService::Maropost::FindLeads.new.call
      end
    end
  end
end
