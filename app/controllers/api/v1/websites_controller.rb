class Api::V1::WebsitesController < ApiController
  before_action :set_website, only: [
      :show, :get_categories, :get_articles,
      :get_category_with_articles, :get_category_article,
      :setup, :build, :rebuild_old, :get_config
  ]

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
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def get_articles
    @articles = @website.articles.order("created_at DESC")
    render json: @articles
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def get_product_cards
    @articles = @website.product_cards.order("created_at DESC")
    render json: @articles
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def get_category_with_articles
    @articles = @website.categories.includes([:articles]).find(params[:category_id]).articles.where(website_id: @website.id).order("created_at DESC")
    render json: @articles
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def get_category_article
    @article = @website.articles.find(params[:article_id])
    render json: @article
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def get_config
    @config = @website.builder_config
    ads = @config[:ads].map {|ad|
      %Q{
          "#{ad.position}": {
            "type": "#{ad.variety}",
            "google_id": "#{ad.google_id}",
            "widget": "#{ad.widget}",
            "innerHTML": `#{ad.innerHTML}`
          }
       }
    }

    site_config = %Q{
          module.exports = {
            "metaTitle": "#{@config[:name]}",
            "metaDescription": "#{@config[:description]}",
            "faviconImageUrl": "#{@config[:favicon_image]}",
            "logoImageUrl": "#{@config[:logo_image]}",
            "logoPath": "/logo.jpg",
            "email": "admin@#{@config[:name]}",
            "adClient": "#{@config[:ad_client]}",
            #{ads.inject {|acc, elem| acc + ", " + elem}}
          }
        }

    render json: {"#{@config[:name].strip}": site_config}
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

  def rebuild_old
    config = @website.builder_config
    context = BuildersInteractor::RebuildOldHost.call({config: config})
    if context.errors
      render json: {errors: context.errors}
    else
      render json: {message: 'success'}
    end
  end

  private
    def set_website
      @website = Website.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: {message: e.message}
    end

    def paginate_items items
      if items.is_a?(Array)
        Kaminari.paginate_array(items).page(params[:page]).per(params[:per])
      else
        items.page(params[:page]).per(params[:per])
      end
    end

end
