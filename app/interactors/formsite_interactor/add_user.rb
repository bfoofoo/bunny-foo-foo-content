module FormsiteInteractor
  class AddUser
    include Interactor

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
        context.formsite_user = formsite.formsite_users.find_or_create_by(ip: request.env['REMOTE_ADDR']).tap do |formsite_user|
          if formsite_user.user.blank?
            formsite_user.update_attributes(formsite_user_params.merge({
              user_id: formsite_user.user_id.blank? ? (user.blank? ? nil : user.id) : formsite_user.user_id,
              is_verified: is_useragent_valid && is_impressionwise_test_success && !is_duplicate,
              is_useragent_valid: is_useragent_valid,
              is_impressionwise_test_success: is_impressionwise_test_success,
              is_duplicate: is_duplicate,
              affiliate: params[:user][:a]
            }))
          end
        end
      end

      def formsite_user_params
        params.require(:user).permit(:user_id, :s1, :s2, :s3, :s4, :s5, :birthday, :phone, :zip)
      end
  end
end
