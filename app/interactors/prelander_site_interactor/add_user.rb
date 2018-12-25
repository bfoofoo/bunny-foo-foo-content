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
      if user.blank?
        if !is_ip_duplicate?
          context.prelander_site_user = prelander_site.prelander_site_users.create(attributes)
        else
          context.prelander_site_user = prelander_site.prelander_site_users.find_by(ip: user_ip)
        end
      else
        prelander_site_user = prelander_site.prelander_site_users.find_by(ip: user_ip)
        if prelander_site_user&.persisted?
          prelander_site_user.update(attributes.merge(is_duplicate: false, is_verified: is_useragent_valid && is_impressionwise_test_success))
          context.prelander_site_user = prelander_site_user
        else
          context.prelander_site_user = prelander_site.prelander_site_users.create(attributes)
        end
      end
    end

    def dynamic_params
      {
        affiliate: params[:user][:a]
      }
    end
  end
end