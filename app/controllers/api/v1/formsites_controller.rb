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
    user = User.create_with(
      first_name: params[:user][:first_name],
      last_name: params[:user][:last_name]
    ).find_or_create_by(email: params[:user][:email])

    formsite_user = @formsite.formsite_users.new(
        user_id: user.id,
        is_verified: FormsiteService.new.is_useragent_valid(request.user_agent)
    )

    render json: {user: user, is_verified: formsite_user.is_verified}
  end

  def setup
    config = @formsite.builder_config
    BuildersInteractor::SetupBuild.call({config: config})
  end

  def build
    config = @formsite.builder_config
    BuildersInteractor::RebuildHost.call({config: config})
  end

  private

  def set_formsite
    @formsite = Formsite.find(params[:id])
  end

  def formsite_params
    params.fetch(:formsite, {}).permit(:id, :name, :description, :droplet_id, :droplet_ip, :zone_id)
  end
end
