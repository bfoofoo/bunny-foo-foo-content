class Api::V1::StatisticsController < ApiController
  def refresh_aweber
    Aweber::FetchStatsJob.perform_async
    head :ok
  end

  def refresh_maropost
    Maropost::FetchStatsJobs.perform_async
    head :ok
  end
end
