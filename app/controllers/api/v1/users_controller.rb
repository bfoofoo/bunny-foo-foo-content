class Api::V1::UsersController < ApiController
  before_action :set_user, only: [:show]
  before_action :authenticate, only: [:create, :update]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    user = User.new(user_params)

    if user.save
      render :show, status: :created, location: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def user_params
    params.fetch(:user, {}).permit(:id, :email, :first_name, :last_name)
  end
end
