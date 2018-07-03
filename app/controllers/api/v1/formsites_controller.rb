class Api::V1::FormsitesController < ApplicationController
  before_action :set_formsite, only: [:show, :add_formsite_user]

  def index
    @formsites = Formsite.all
    render json: @formsites
  end

  def show
    render json: @formsite
  end

  def add_formsite_user
    user = User.find_or_create_by(email: params[:user].email)
    formsite_user = @formsite.formsite_users.new(user_id: user.id, formsite_id: @formsite.id, is_verified: true)
    render json: {user: user, is_verified: formsite_user.is_verified}
  end

  private

  def set_formsite
    @formsite = Formsite.find(params[:id])
  end

  def formsite_params
    params.fetch(:formsite, {}).permit(:id, :name, :description, :droplet_id, :droplet_ip, :zone_id)
  end
end
