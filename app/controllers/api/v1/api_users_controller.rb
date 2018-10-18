class Api::V1::ApiUsersController < ApiController
  include Swagger::Blocks

  before_action :set_api_user, only: [:show, :update]
  before_action :set_api_client, only: [:create]
  before_action :authenticate, only: [:create, :update]


  swagger_path '/api_users/' do
    operation :post do
      security do
        key :api_key, []
      end
      key :produces, [
        'application/json'
      ]
      key :summary, 'Add new api user'
      key :operationId, 'createNewApiUser'
      key :tags, [
          'api_user'
      ]
      parameter do
        key :name, :api_user
        key :in, :body
        key :required, true
        schema do
          key :'$ref', :ApiUserInput
        end
      end
      
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  def index
    @api_users = ApiUser.all
    render json: @api_users
  end

  def show
    render json: @api_user
  end

  def create
    formsite_service = FormsiteService.new

    is_useragent_valid = formsite_service.is_useragent_valid(request.user_agent)
    is_impressionwise_test_success = formsite_service.is_impressionwise_test_success(api_user_params)
    is_duplicate = ApiUser.where("email = ?", api_user_params[:email]).exists?

    @api_user = ApiUser.new(
        api_user_params.merge(
            api_client_id: @api_client.id,
            is_verified: is_useragent_valid && is_impressionwise_test_success && !is_duplicate,
            is_useragent_valid: is_useragent_valid,
            is_impressionwise_test_success: is_impressionwise_test_success,
            is_duplicate: is_duplicate
        )
    )

    if @api_user.save
      ApiUser::AddNewUserToAweberUseCase.new(@api_user).perform
      ApiUser::AddNewUserToAdopiaUseCase.new(@api_user).perform
      ApiUser::AddNewUserToEliteUseCase.new(@api_user).perform
      ApiUser::AddNewUserToOngageUseCase.new(@api_user).perform
      render json: {message: 'success'}, status: 200
    else
      render json: @api_user.errors, status: :unprocessable_entity
    end
  rescue => e
    render json: {message: e.message}, status: 500
  end

  private
  def set_api_client
    authenticate_with_http_token do |token, options|
      @api_client = ApiClient.find_by_token(token)
    end
  rescue => e
    render json: {message: e.message}
  end

  def set_api_user
    @api_user = ApiUser.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def api_user_params
    params.require(:api_user).permit(:id, :email, :first_name, :last_name, :is_verified, :is_useragent_valid, :is_impressionwise_test_success, :is_duplicate, :s1, :s2, :s3, :s4, :s5, :website, :api_client_id, :ip, :captured, :lead_id, :zip, :state, :phone1, :job)
  end

end
