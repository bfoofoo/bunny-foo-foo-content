class Api::V1::PrelanderSitesController < ApiController
    before_action :set_prelander_site, only: [
      :show, :get_prelander_site_questions, :get_question_by_position,
      :setup, :build, :rebuild_old, :get_config, :add_prelander_site_user
    ]
  
    def index
      @sites = PrelanderSite.all
      render json: @sites
    end
  
    def show
      render json: @prelander_site
    end
  
    def get_config
      @config = @prelander_site.builder_config
  
      site_config = %Q{
            module.exports = {
              "metaTitle": "#{@config[:name]}",
              "metaDescription": "#{@config[:description]}",
              "faviconImageUrl": "#{@config[:favicon_image]}",
              "logoImageUrl": "#{@config[:logo_image]}",
              "logoPath": "/logo.jpg",
              "email": "admin@#{@config[:name]}",
            }
          }
  
      render json: {
        "#{@config[:name].strip}": site_config,
        "site_info": @config
      }
    end

    def get_prelander_site_questions
        @questions = @prelander_site.questions.order_by_position.includes(:answers)
        render json: @questions
    end
  
    def get_question_by_position
      @question = @prelander_site.questions.find_by(position: params[:position])
      render json: @question
    end
  
    def add_prelander_site_user
      prelander_site_interactor = PrelanderSiteInteractor::AddUser.call({
        params: params,
        request: request,
        prelander_site: @prelander_site
      })
  
      render json: prelander_site_interactor.api_response
    end
  
    def unsubscribe_user
      if params[:email].present?
        user = User.find_by(email: params[:email])
        if user.present?
          user.update(unsubscribed_at: DateTime.current)
          render json: {message: 'success'}
        else
          render json: {message: 'user not found'}
        end
      else
        render json: {message: 'email required'}
      end
    end
  
    def setup
      config = @prelander_site.builder_config
      context = BuildersInteractor::SetupBuild.call({config: config})
      if context.errors
        render json: {errors: context.errors}
      else
        render json: {message: 'success'}
      end
    end
  
    def build
      config = @prelander_site.builder_config
      context = BuildersInteractor::RebuildHost.call({config: config})
      if context.errors
        render json: {errors: context.errors}
      else
        render json: {message: 'success'}
      end
    end
  
    def rebuild_old
      config = @prelander_site.builder_config
      context = BuildersInteractor::RebuildOldHost.call({config: config})
      if context.errors
        render json: {errors: context.errors}
      else
        render json: {message: 'success'}
      end
    end
  
    private
  
    def prelander_site_params
      params.fetch(:prelander_site, {}).permit(:id, :name, :description, :droplet_id, :droplet_ip, :zone_id)
    end
  
    def set_prelander_site
      @prelander_site = PrelanderSite.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }
    end
  end
  