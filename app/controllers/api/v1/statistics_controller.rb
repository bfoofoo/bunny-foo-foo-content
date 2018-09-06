class Api::V1::StatisticsController < ApiController
  def refresh_aweber
    Aweber::FindLeadsJob.perform_async
    head :ok
  end
end
