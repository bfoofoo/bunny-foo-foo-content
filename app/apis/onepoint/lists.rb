module Onepoint
  class Lists < Resource
    def all(params = {})
      response = @request.get(nil, params)
      Response.new(response).parse
    end

    private

    def base_path
      'lists'
    end
  end
end
