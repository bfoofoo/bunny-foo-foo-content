class Api::V1::FormsitesController < ApiController
  before_action :set_formsite, only: [:show, :add_formsite_user, :get_formsite_questions, :setup, :build]
  before_action :authenticate, only: [:create, :update]

  def index
    @formsites = Formsite.all
    render json: @formsites
  end

  def show
    render json: @formsite
  end

  def get_formsite_questions
    @questions = @formsite.questions.order_by_position.includes(:answers)
    render json: @questions
  end

  def add_formsite_user
    formsite_interactor = FormsiteInteractor::AddUser.call({
      params: params,
      request: request,
      formsite: @formsite
    })

    if formsite_interactor.api_response[:is_verified]
      Formsite::AddNewUserToAweberUseCase.new(@formsite, formsite_interactor.user, formsite_interactor.formsite_user).perform
      Formsite::AddNewUserToMaropostUseCase.new(@formsite, formsite_interactor.user, formsite_interactor.formsite_user).perform
    end

    render json: formsite_interactor.api_response
  end

  def setup
    config = @formsite.builder_config
    context = BuildersInteractor::SetupBuild.call({config: config})
    if context.errors
      render json: {errors: context.errors}
    else
      render json: {message: 'success'}
    end
  end

  def build
    config = @formsite.builder_config
    context = BuildersInteractor::RebuildHost.call({config: config})
    if context.errors
      render json: {errors: context.errors}
    else
      render json: {message: 'success'}
    end
  end

  private

  def set_formsite
    @formsite = Formsite.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def formsite_params
    params.fetch(:formsite, {}).permit(:id, :name, :description, :droplet_id, :droplet_ip, :zone_id)
  end
end
