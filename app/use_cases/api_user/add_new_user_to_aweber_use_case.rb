class ApiUser
  class AddNewUserToAweberUseCase
    attr_reader :api_user

    AFFILIATE_MAPPING = {
      'Fluent' => 'fluent',
      'Propath - collegefinderhelper.com' => 'pp',
      'Propath - myjobfinders.com' => 'pp'
    }.freeze

    def initialize(api_user)
      @api_user = api_user
    end

    def perform
      return false unless api_user.is_verified
      params = { affiliate: AFFILIATE_MAPPING[api_user.api_client&.name] }.compact
      lists.each do |list|
        EmailMarketerService::Aweber::SubscriptionsService.new(list: list, params: params).add_subscriber(api_user)
      end
    end

    private

    def lists
      ApiClientMapping.where(source: api_user.api_client).to_a.map(&:destination)
    end
  end
end
