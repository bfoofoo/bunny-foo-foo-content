module Aweber
  class FindLeadsJob
    include SuckerPunch::Job

    def perform
      EmailMarketerService::Aweber::FindLeads.new.call
    end
  end
end
