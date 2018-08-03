class Api::V1::ArticlesController < ApiController
  include Swagger::Blocks
  before_action :set_article, only: [:show]
  before_action :authenticate, only: [:create]

  swagger_path '/articles/' do
    operation :get do
      key :summary, 'Get all articles'
    end
  end

  swagger_path '/articles/{id}' do
    operation :get do
      key :summary, 'Find Article by ID'
      key :operationId, 'findArticleById'
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of article to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'article response'
        schema do
          key :'$ref', :Article
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
    @articles = Article.all.order("created_at DESC")
    render json: @articles
  end

  def show
    render json: @article
  end

  def create
    @article  = Article.new(article_params)
    if @article.save
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  rescue => e
    render json: {message: e.message}
  end

  private
    def set_article
      @article = Article.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: {message: e.message}
    end

    def article_params
      params.require(:article).permit(:id, :name, :content, :short, :category_id, :slug, :cover_image, :website_id)
    end
end
