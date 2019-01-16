module ApiUsers
  class CreateApiUsersWorker
    include Sidekiq::Worker

    def perform(api_users, user_agent, api_client_id, context)
      skip_name_validations = context != :strict
      api_users = JSON.parse(api_users)
      api_users.each do |api_user_params|
        api_user_params = ActionController::Parameters.new(api_user_params)
        ApiUser::CreateApiUserUseCase.new(api_user_params, user_agent, api_client(api_client_id), skip_name_validations).perform
      end
    end

    private
    def api_client(api_client_id)
      @api_client ||= ApiClient.find(api_client_id)
    end
  end
end
