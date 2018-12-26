module PrelanderSiteInteractor
  class AddUser
    include Interactor

    delegate :prelander_site, :params, :request, :prelander_site_user, :to => :context

    def call
      create_prelander_site_user
      context.api_response = {prelander_site_user: prelander_site_user}
    end

    def rollback; end

    private

    def user_ip
      if !params.dig(:ip).blank?
        params.dig(:ip)
      else
        request.env['REMOTE_ADDR']
      end
    end
    
    def create_prelander_site_user
      handle_site_user_creation
    end

    def handle_site_user_creation
      attributes =    dynamic_params
                     .merge({ ip: user_ip })
      context.prelander_site_user = prelander_site.prelander_site_users.create(attributes)
    end

    def dynamic_params
      {
        affiliate: params[:a]
      }
    end
  end
end