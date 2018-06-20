class Api::V1::WebsitesController < ApiController
  before_action :set_website, only: [:show]

  def index
    @websites = Website.all
    render json: @websites
  end

  def show
    render json: @website
  end

  private
    def set_website
      @website = Website.find(params[:id])
    end

end
