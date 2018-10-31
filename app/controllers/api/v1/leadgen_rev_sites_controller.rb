class Api::V1::LeadgenRevSitesController < ApiController
  before_action :set_leadgen_rev_site, only: [
    :show, :get_categories, :get_category_with_articles, :get_leadgen_rev_site_question,
    :setup, :build, :rebuild_old, :get_config, :add_leadgen_rev_site_user
  ]

  def index
    @sites = LeadgenRevSite.all
    render json: @sites
  end

  # TODO use jbuilder to build json
  def show
    render json: {
      **@leadgen_rev_site.attributes.slice('name', 'short_name', 'favicon_image', 'logo_image', 'background', 'created_at', 'updated_at').deep_symbolize_keys,
      content: @leadgen_rev_site.attributes.slice('first_question_code_snippet', 'left_side_content', 'right_side_content', 'head_code_snippet'),
      options: @leadgen_rev_site.attributes.slice('is_thankyou', 'is_phone_number', 'is_checkboxes', 'droplet_id', 'ad_client',
                                                  'droplet_ip', 'zone_id', 'repo_url', 'first_redirect_url', 'final_redirect_url',
                                                  's1_description', 's2_description', 's3_description', 's4_description', 's5_description',
                                                  'form_box_title_text', 'affiliate_description'),
      ads: @leadgen_rev_site.ads,
      trackers: @leadgen_rev_site.trackers
    }
  end

  def get_categories
    @categories = @leadgen_rev_site.categories
    render json: @categories
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def get_category_with_articles
    @articles = @leadgen_rev_site.categories.includes([:articles]).find(params[:category_id]).articles.where(leadgen_rev_site_id: @leadgen_rev_site.id).order("created_at DESC")
    render json: @articles
  rescue ActiveRecord::RecordNotFound => e
    render json: {message: e.message}
  end

  def get_config
    @config = @leadgen_rev_site.builder_config
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
            "textFile": "#{@config[:text_file]}",
            "logoImageUrl": "#{@config[:logo_image]}",
            "logoPath": "/logo.jpg",
            "email": "admin@#{@config[:name]}",
            "adClient": "#{@config[:ad_client]}",
            #{ads.inject {|acc, elem| acc + ", " + elem}}
          }
        }

    render json: {"#{@config[:name].strip}": site_config}
  end

  def get_leadgen_rev_site_question
    @question = @leadgen_rev_site.questions.find_by(position: params[:position])
    render json: @question
  end

  def add_leadgen_rev_site_user
    leadgen_rev_site_interactor = LeadgenRevSiteInteractor::AddUser.call({
      params: params,
      request: request,
      leadgen_rev_site: @leadgen_rev_site
    })

    if leadgen_rev_site_interactor.api_response[:is_verified]
      leadgen_rev_site::AddNewUserToEspUseCase.new(@leadgen_rev_site, leadgen_rev_site_interactor.user, leadgen_rev_site_interactor.leadgen_rev_site_user).perform
    end

    render json: leadgen_rev_site_interactor.api_response
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
    config = @leadgen_rev_site.builder_config
    context = BuildersInteractor::SetupBuild.call({config: config})
    if context.errors
      render json: {errors: context.errors}
    else
      render json: {message: 'success'}
    end
  end

  def build
    config = @leadgen_rev_site.builder_config
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

  def leadgen_rev_site_params
    params.fetch(:leadgen_rev_site, {}).permit(:id, :name, :description, :droplet_id, :droplet_ip, :zone_id)
  end

  def set_leadgen_rev_site
    @leadgen_rev_site = LeadgenRevSite.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }
  end
end
