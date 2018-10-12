module Adopia
  class Client
    def initialize(api_key)
      @request = Request.new(api_key)
    end

    def pull_user_lists
      response = @request.get(self_path)
      data = Response.new(response).parse
      Resources::Lists.new(data).collection
    end

    private

    # get camelcase version of (caller) method name
    def self_path
      caller_locations(1,1)[0].label.to_s.camelize(:lower)
    end
  end
end
