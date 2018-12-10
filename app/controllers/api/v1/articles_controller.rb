class Api::V1::ArticlesController < ApiController
  before_action :set_article, only: [:show]
  before_action :authenticate, only: [:create, :update]

  def index
    @articles = Article.includes(:article_popups  ).all.order("created_at DESC")
    if params[:leadgen_rev_site_id] || params[:category_id]
      query = @articles.joins(:articles_leadgen_rev_sites).where({
        articles_leadgen_rev_sites: {leadgen_rev_site_id: params[:leadgen_rev_site_id]},
        category_id: params[:category_id]
      }.compact)
      return render json: paginate_items(query)
    end
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
      params.require(:article).permit(:id, :name, :content, :short, :category_id, :slug, :cover_image, :website_id, :leadgen_rev_site_id)
    end
end
