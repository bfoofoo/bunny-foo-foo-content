module ApiUsers
  class RefreshImpressionwiseApiUsersWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'api_users_refresh'

    def perform(api_users_ids)
      api_users(api_users_ids).each do |api_user|
        is_impressionwise_test_success = is_impressionwise_test_success?(api_user)
        is_verified = api_user.is_useragent_valid && is_impressionwise_test_success && !api_user.is_duplicate
        api_user.update({
          is_impressionwise_test_success: is_impressionwise_test_success,
          is_verified: is_verified
        })

        if is_verified
          send_to_esp(api_user) 
        end
      end
    end

    private

    def send_to_esp(user)
      ApiUser::AddNewUserToEspUseCase.new(user).perform
    end

    def api_users(ids)
      @api_users ||= ApiUser.where(id: ids)
    end

    def formsite_service
      @formsite_service ||= FormsiteService.new
    end

    def is_impressionwise_test_success?(user)
      return false if user.blank?
      formsite_service.is_impressionwise_test_success(user)
    end

  end
end
