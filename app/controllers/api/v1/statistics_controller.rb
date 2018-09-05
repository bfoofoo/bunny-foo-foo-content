class Api::V1::StatisticsController < ApiController
  def refresh_aweber
    service = EmailMarketerService::Aweber::FindLeads.new
    if service.call
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
