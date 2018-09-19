module FormsiteInteractor
  class AddUser
    include Interactor
    # FORMSITE_NAME="openposition.us"
    FORMSITE_NAME="theresourcefinder.info"

    delegate :formsite, :params, :request, :user, :formsite_user, :to => :context

    def call
      create_user
      create_formsite_user
      context.api_response = {user: user, is_verified: formsite_user.is_verified, formsite_user: formsite_user}
    end

    def rollback
    end

    private

      def formsite_service
        @formsite_service ||= FormsiteService.new()
      end

      def is_useragent_valid
        formsite_service.is_useragent_valid(request.user_agent)
      end

      def is_impressionwise_test_success
        return false if user.blank?
        formsite_service.is_impressionwise_test_success(user)
      end

      def is_duplicate
        return false if user.blank?
        !formsite.formsite_users.joins(:user).where("users.email = ?", user.email).blank?
      end

      def create_user
        return if params[:user][:email].blank?
        context.user = User.create_with(
          first_name: params[:user][:first_name],
          last_name: params[:user][:last_name]
        ).find_or_create_by(email: params[:user][:email])
      end

      def create_formsite_user
        if formsite && formsite.name == FORMSITE_NAME && !user.blank?
          handle_openposition_formsite()
        else
          context.formsite_user = formsite.formsite_users.find_or_create_by(ip: request.env['REMOTE_ADDR']).tap do |formsite_user|
            formsite_user.job_key = params[:user][:key]
            if formsite_user.user.blank?
              attributes = formsite_user_params
                .merge(formsite_user_dynamic_params)
                .merge({
                  user_id: formsite_user.user_id.blank? ? (user.blank? ? nil : user.id) : formsite_user.user_id
                })

              formsite_user.update_attributes(attributes)
            end
          end
        end
      end

      def handle_openposition_formsite
        attributes = formsite_user_params
                .merge(formsite_user_dynamic_params)
                .merge({
                  ip: request.env['REMOTE_ADDR'],
                  user_id: user.id
                })

        formsite_user = formsite.formsite_users.find_by(ip: request.env['REMOTE_ADDR'], user_id: nil)

        if formsite_user.persisted?
          formsite_user.update(attributes)
        else
          context.formsite_user = formsite.formsite_users.create(attributes)
        end
      end

      def formsite_user_dynamic_params
        {
          is_verified: is_useragent_valid && is_impressionwise_test_success && !is_duplicate,
          is_useragent_valid: is_useragent_valid,
          is_impressionwise_test_success: is_impressionwise_test_success,
          is_duplicate: is_duplicate,
          affiliate: params[:user][:a],
          job_key: params[:user][:key]
        }
      end

      def formsite_user_params
        params.require(:user).permit(:user_id, :s1, :s2, :s3, :s4, :s5, :birthday, :phone, :zip)
      end
  end
end
