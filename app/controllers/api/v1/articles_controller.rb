class Api::V1::ArticlesController < ApiController
  before_action :set_article, only: [:show]

  def index
    @articles = Article.all
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
  rescue ActiveRecord::RecordNotFound => e
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
