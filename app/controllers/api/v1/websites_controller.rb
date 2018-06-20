class Api::V1::WebsitesController < ApiController
  before_action :set_website, only: [:show, :get_categories, :get_articles, :get_category_with_articles, :get_category_article]

  def index
    @websites = Website.all
    render json: paginate_items(@websites)
  end

  def show
    render json: @website
  end

  def get_categories
    @categories = @website.categories
    render json: @categories
  end

  def get_articles
    @articles = @website.articles
    render json: paginate_items(@articles)
  end


  def get_category_with_articles
    @articles = @website.categories.find(params[:category_id]).articles
    render json: @articles
  end

  def get_category_article
    @article = @website.articles.find(params[:article_id])
    render json: @article
  end

  private
    def set_website
      @website = Website.find(params[:id])
    end

    def paginate_items items
      if items.is_a?(Array)
        Kaminari.paginate_array(items).page(params[:page]).per(params[:per])
      else
        items.page(params[:page]).per(params[:per])
      end
    end

end
