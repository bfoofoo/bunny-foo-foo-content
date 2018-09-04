class Api::V1::SuppressionListsController < ApiController
  before_action :authenticate_url, only: [:download]

  def download
    render json: {}
  end
end
