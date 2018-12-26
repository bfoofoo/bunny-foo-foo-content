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
      if !params.dig(:user, :ip).blank?
        params.dig(:user, :ip)
      else
        request.env['REMOTE_ADDR']
      end
    end
    
    def create_prelander_site_user
      handle_site_user_creation
    end

    def handle_site_user_creation
      attributes = prelander_site_user_params
                     .merge(dynamic_params)
                     .merge({ ip: user_ip })
      if !is_ip_duplicate?
        context.prelander_site_user = prelander_site.prelander_site_users.create(attributes)
      else
        context.prelander_site_user = prelander_site.prelander_site_users.find_by(ip: user_ip)
      end
    end

    def dynamic_params
      {
        affiliate: params[:user][:a]
      }
    end
  end
end