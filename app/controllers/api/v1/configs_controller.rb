class Api::V1::ConfigsController < ApplicationController
  before_action :set_config, only: [:show]

  def index
    @configs = Config.all
    render json: @configs
  end

  def show
    render json: @config
  end

  private
  def set_config
    @config = Config.find(params[:id])
  end
end
