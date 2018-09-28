class ApiUser
  class AddNewUserToAweberUseCase
    attr_reader :api_user

    def initialize(api_user)
      @api_user = api_user
    end

    def perform
      return false unless api_user.is_verified
      mappings.each do |mapping|
        params = { affiliate: mapping.tag }.compact
        EmailMarketerService::Aweber::SubscriptionsService.new(list: mapping.destination, params: params).add_subscriber(api_user)
      end
    end

    private

    def mappings
      ApiClientMapping.where(source: api_user.api_client)
    end
  end
end
