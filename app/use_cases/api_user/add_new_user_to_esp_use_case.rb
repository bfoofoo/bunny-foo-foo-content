class ApiUser
  class AddNewUserToEspUseCase
    attr_reader :api_user

    def initialize(api_user)
      @api_user = api_user
    end

    def perform
      return false unless api_user.is_verified
      mappings.each do |mapping|
        yield(mapping)
      end
    end

    private

    def mappings
      ApiClientMappings::Base
        .where(source: api_user.api_client, destination_type: list_class, delay_in_hours: 0)
    end

    def list_class
      raise NotImplementedError
    end
  end
end
