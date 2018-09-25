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
      EmailMarketerService::Aweber::SubscriptionsService.new(list: list, params: params).add_subscriber(api_user)
    end

    private

    # TODO this will be managed through admin panel
    def list
      AweberList.find_by(name: 'National Consumer Center')
    end
  end
end
