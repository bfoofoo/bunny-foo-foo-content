module Aweber
  class FindLeadsJob
    include SuckerPunch::Job

    def perform
      ActiveRecord::Base.connection_pool.with_connection do
        EmailMarketerService::Aweber::FindLeads.new.call
      end
    end
  end
end
