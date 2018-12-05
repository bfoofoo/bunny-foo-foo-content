class Api::V1::FormsitesController < ApiController
  before_action :set_formsite, only: [:show, :add_formsite_user, :get_formsite_questions, :get_formsite_question, :setup, :build]
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

  def get_formsite_question
    @question = @formsite.questions.find_by(position: params[:position])
    render json: @question
  end

  def add_formsite_user
    formsite_interactor = FormsiteInteractor::AddUser.call({
      params: params,
      request: request,
      formsite: @formsite
    })

    if formsite_interactor.api_response[:is_verified]
      Formsite::AddNewUserToEspUseCase.new(@formsite, formsite_interactor.user, formsite_interactor.formsite_user).perform
    end

    render json: formsite_interactor.api_response
  end

  def unsubscribe_user
    if params[:email].present?
      user = User.find_by(email: params[:email])
      if user.present?
        user.update(unsubscribed: true) if user.present?
        render json: {message: 'success'}
      else
        render json: {message: 'user not found'}
      end
    else
      render json: {message: 'email required'}
    end
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
    if params.dig(:user, :site_type) == "revenue"
      @formsite = Website.find(params[:id])
    else
      @formsite = Formsite.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def formsite_params
    params.fetch(:formsite, {}).permit(:id, :name, :description, :droplet_id, :droplet_ip, :zone_id)
  end
end
