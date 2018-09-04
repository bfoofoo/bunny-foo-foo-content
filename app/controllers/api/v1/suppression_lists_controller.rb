require 'zip'
class Api::V1::SuppressionListsController < ApiController
  before_action :authenticate_url, only: [:download]

  def download
    response = SuppressionLists::GenerateSuppressionListsZipInteractor.call({params: params})
    if response.success?
      send_file response.generated_zip, type: "application/zip", disposition: "attachment", filename: "SuppressionLists.zip"
    else
      render json: response.error_message, status: :unprocessable_entity
    end
  end
end
