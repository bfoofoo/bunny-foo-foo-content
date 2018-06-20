class Api::V1::WebsitesController < ApiController
  def index
    render json: {test: 'test1'}
  end

  def show
    render json: {test: 'test2'}
  end
end
