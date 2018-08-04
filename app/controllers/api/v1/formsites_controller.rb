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
    @questions = @formsite.questions.includes(:answers)
    render json: @questions
  end

  def add_formsite_user
    formsite_service = FormsiteService.new()

    user = User.create_with(
      first_name: params[:user][:first_name],
      last_name: params[:user][:last_name]
    ).find_or_create_by(email: params[:user][:email])

    is_useragent_valid = formsite_service.is_useragent_valid(request.user_agent)
    is_impressionwise_test_success = formsite_service.is_impressionwise_test_success(user)
    is_duplicate =  !@formsite.formsite_users.joins(:user).where("users.email = ?", user.email).blank?

    formsite_user = @formsite.formsite_users.create!(
        user_id: user.id,
        s1: params[:user][:s1],
        s2: params[:user][:s2],
        s3: params[:user][:s3],
        s4: params[:user][:s4],
        s5: params[:user][:s5],
        ndm_token: params[:user][:ndm_token],
        is_verified: is_useragent_valid && is_impressionwise_test_success && !is_duplicate,
        is_useragent_valid: is_useragent_valid,
        is_impressionwise_test_success: is_impressionwise_test_success,
        is_duplicate: is_duplicate
    )

    render json: {user: user, is_verified: formsite_user.is_verified}
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
