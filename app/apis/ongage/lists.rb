module Ongage
  class Lists
    def initialize(auth_headers)
      @request = Request.new(auth_headers, 'lists')
    end

    def all
      response = @request.get(nil)
      Response.new(response).parse
    end
  end
end
