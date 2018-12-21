class ApiUser
  class CreateApiUserUseCase

    attr_reader :params, :user_agent, :api_client

    def initialize(params, user_agent, api_client)
      @params  = params
      @user_agent = user_agent
      @api_client = api_client
    end

    def perform
      if !params[:api_users].blank?
        create_multiple_users
      else
        create_api_user
      end
    end
    
    private
    
    def create_multiple_users
      ApiUsers::CreateApiUsersWorker.perform_async(
        params[:api_users].to_json,
        user_agent, 
        api_client.id
      )
      return {message: "success", status: 200}
    end

    def user_state_for_ip(ip)
      GeocoderInteractor::GetStateByIP.call(ip: user_ip)&.state
    rescue
      nil
    end

    def create_api_user
      @user = build_api_user(params)
      if @user.save
        send_to_esp
        return {message: "success", status: 200}
      else
        return {message: @user.errors, status: :unprocessable_entity}
      end
    end
    
    def formsite_service
      @formsite_service ||= FormsiteService.new
    end
    
    def is_useragent_valid
      @is_useragent_valid ||= formsite_service.is_useragent_valid(user_agent)
    end
    
    def is_impressionwise_test_success(api_user_params)
      formsite_service.is_impressionwise_test_success(api_user_params)
    end

    def is_duplicate(email)
      ApiUser.where("email = ? AND created_at >= ?", email, LOOKBACK_PERIOD.ago).exists?
    end

    def build_api_user(params)
      parsed_params = api_user_params(params)
      @api_user = ApiUser.new(
        parsed_params.merge(
            api_client_id: api_client.id,
            state: user_state_for_ip(parsed_params[:ip]),
            is_verified: is_useragent_valid && is_impressionwise_test_success(parsed_params) && !is_duplicate(parsed_params[:email]),
            is_useragent_valid: is_useragent_valid,
            is_impressionwise_test_success: is_impressionwise_test_success(parsed_params),
            is_duplicate: is_duplicate(parsed_params[:email])
        )
      )
    end

    def send_to_esp
      ApiUser::AddNewUserToEspUseCase.new(@user).perform
    end

    def api_user_params(user_params)
      user_params.require(:api_user).permit(:id, :email, :first_name, :last_name, :is_verified, :is_useragent_valid, :is_impressionwise_test_success, :is_duplicate, :s1, :s2, :s3, :s4, :s5, :website, :api_client_id, :ip, :captured, :lead_id, :zip, :state, :phone1, :job)
    end

  end
end
