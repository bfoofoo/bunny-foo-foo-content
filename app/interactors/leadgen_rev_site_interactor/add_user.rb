module LeadgenRevSiteInteractor
  class AddUser
    include Interactor

    delegate :leadgen_rev_site, :params, :request, :user, :leadgen_rev_site_user, :to => :context

    def call
      create_user
      create_leadgen_rev_site_user
      context.api_response = {user: user, is_verified: leadgen_rev_site_user&.is_verified, leadgen_rev_site_user: leadgen_rev_site_user, sms_compliant: leadgen_rev_site_user&.sms_compliant}
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

    def user_state
      GeocoderInteractor::GetStateByIP.call(ip: user_ip)&.state
    rescue
      nil
    end

    def leadgen_rev_site_service
      @leadgen_rev_site_service ||= FormsiteService.new
    end

    def is_useragent_valid
      leadgen_rev_site_service.is_useragent_valid(request.user_agent)
    end

    def is_impressionwise_test_success
      return false if user.blank?
      leadgen_rev_site_service.is_impressionwise_test_success(user)
    end

    def is_email_duplicate
      return false if user.blank?
      !leadgen_rev_site.leadgen_rev_site_users.joins(:user).where("users.email = ? AND users.created_at >= ?", user.email, LOOKBACK_PERIOD.ago).blank?
    end

    def is_ip_duplicate?
      !leadgen_rev_site.leadgen_rev_site_users.where('leadgen_rev_site_users.ip = ? AND leadgen_rev_site_users.created_at >= ?', user_ip, LOOKBACK_PERIOD.ago).blank?
    end

    def create_user
      return if params[:user][:email].blank?
      context.user = User.create_with(
        first_name: params[:user][:first_name],
        last_name: params[:user][:last_name]
      ).find_or_create_by(email: params[:user][:email])
    end

    def create_leadgen_rev_site_user
      if user.try(:email) == LeadgenRevSiteUser::TEST_USER_EMAIL
        create_test_user
      else
        handle_site_user_creation
      end
    end

    def create_test_user
      attributes = leadgen_rev_site_user_params
                     .merge(dynamic_params)
                     .merge({
                              is_verified: true,
                              is_useragent_valid: true,
                              is_impressionwise_test_success: true,
                              is_duplicate: false,
                              ip: user_ip,
                              user_id: user.id,
                              state: user_state
                            })
      context.leadgen_rev_site_user = leadgen_rev_site.leadgen_rev_site_users.create(attributes)
    end

    def handle_site_user_creation
      attributes = leadgen_rev_site_user_params
                     .merge(dynamic_params)
                     .merge({
                              ip: user_ip,
                              state: user_state,
                              user_agent: request.user_agent
                            })

      if user.blank?
        if !is_ip_duplicate?
          attributes = attributes.merge({
                                          is_duplicate: is_ip_duplicate?
                                        })
          context.leadgen_rev_site_user = leadgen_rev_site.leadgen_rev_site_users.create(attributes)
        else
          context.leadgen_rev_site_user = leadgen_rev_site.leadgen_rev_site_users.find_by(ip: user_ip, user_id: nil)
        end
      else
        leadgen_rev_site_user = leadgen_rev_site.leadgen_rev_site_users.find_by(ip: user_ip, user_id: nil)
        attributes = attributes.merge({user_id: user.id})
        if leadgen_rev_site_user&.persisted?
          leadgen_rev_site_user.update(attributes.merge(is_duplicate: false, is_verified: is_useragent_valid && is_impressionwise_test_success))
          context.leadgen_rev_site_user = leadgen_rev_site_user
        else
          attributes = attributes.merge({
                                          is_duplicate: is_ip_duplicate?
                                        })
          context.leadgen_rev_site_user = leadgen_rev_site.leadgen_rev_site_users.create(attributes)
        end
      end
    end

    def dynamic_params
      is_verified = is_useragent_valid && is_impressionwise_test_success && !is_ip_duplicate?
      is_verified = is_verified && !params[:user][:first_name].blank? && !params[:user][:last_name].blank?
      {
        is_verified: is_verified,
        is_useragent_valid: is_useragent_valid,
        is_impressionwise_test_success: is_impressionwise_test_success,
        is_duplicate: is_ip_duplicate?,
        is_email_duplicate: is_email_duplicate,
        affiliate: params[:user][:a],
        job_key: params[:user][:key],
        from_prelander: from_prelander
      }
    end

    def from_prelander
      prelander_answers_params.present?
    end

    def prelander_answers_params
      params.fetch(:prelander_answers, {})&.permit! || nil
    end

    def leadgen_rev_site_user_params
      params.require(:user).permit(:user_id, :s1, :s2, :s3, :s4, :s5, :birthday, :phone, :zip, :url, :sms_compliant)
    end
  end
end
