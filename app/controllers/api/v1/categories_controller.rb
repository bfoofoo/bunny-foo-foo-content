class Api::V1::CategoriesController < ApiController
  before_action :set_category, only: [:show]
  before_action :authenticate, only: [:create, :update]

  def index
    @categories = Category.all
    render json: @categories
  end

  def show
    render json: @category
  end

  def create
    @category  = Category.new(category_params)
    if @category.save
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  private
  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def category_params
    params.require(:category).permit(:id, :name, :slug, :description, :website_ids, website_ids: [])
  end
end
