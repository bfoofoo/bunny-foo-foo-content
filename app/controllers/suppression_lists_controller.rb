require 'zip'
class SuppressionListsController < ApplicationController
  before_action :authenticate_url, only: [:download]

  def index
  end

  def download
    response = SuppressionLists::GenerateSuppressionListsZipInteractor.call({params: params})
    if response.success?
      send_file response.generated_zip, type: "application/zip", disposition: "attachment", filename: "SuppressionLists.zip"
    else
      flash[:notice] = response.error_message[:message]
      render :index
    end
  end
end
