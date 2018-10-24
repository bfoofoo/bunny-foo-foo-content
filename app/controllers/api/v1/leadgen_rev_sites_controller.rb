class Api::V1::LeadgenRevSitesController < ApiController
  before_action :authenticate, only: [:create, :update]
  before_action :set_website, only: [
    :show, :get_categories, :get_articles, :get_product_cards,
    :get_category_with_articles, :get_category_article,
    :setup, :build, :rebuild_old, :get_config,
    :add_formsite_user, :get_formsite_questions, :get_formsite_question
  ]

  def index
    @sites = LeadgenRevSite.all
    render json: @sites
  end

  def show
    render json: @website
  end

  def get_formsite_questions
    @questions = @website.questions.order_by_position.includes(:answers)
    render json: @questions
  end

  def get_formsite_question
    @question = @website.questions.find_by(position: params[:position])
    render json: @question
  end

  def add_formsite_user
    formsite_interactor = LeadgenRevSiteInteractor::AddUser.call({
      params: params,
      request: request,
      website: @website
    })

    if formsite_interactor.api_response[:is_verified]
      website::AddNewUserToEspUseCase.new(@website, formsite_interactor.user, formsite_interactor.formsite_user).perform
    end

    render json: formsite_interactor.api_response
  end

  def unsubscribe_user
    user = User.find_by(email: params[:email])
    if user.present?
      user.update(unsubscribed: true) if user.present?
      render json: {message: 'success'}
    else
      render json: {message: 'user not found'}
    end
  end

  def setup
    config = @website.builder_config
    context = BuildersInteractor::SetupBuild.call({config: config})
    if context.errors
      render json: {errors: context.errors}
    else
      render json: {message: 'success'}
    end
  end

  def build
    config = @website.builder_config
    context = BuildersInteractor::RebuildHost.call({config: config})
    if context.errors
      render json: {errors: context.errors}
    else
      render json: {message: 'success'}
    end
  end

  private

  def formsite_params
    params.fetch(:website, {}).permit(:id, :name, :description, :droplet_id, :droplet_ip, :zone_id)
  end

  def set_website
    @website = LeadgenRevSite.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }
  end

  def paginate_items items
    if items.is_a?(Array)
      Kaminari.paginate_array(items).page(params[:page]).per(params[:per])
    else
      items.page(params[:page]).per(params[:per])
    end
  end
end
