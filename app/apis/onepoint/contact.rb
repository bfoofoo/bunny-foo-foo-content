module Onepoint
  class Contact < Resource
    def create(params)
      response = @request.post(nil, params.compact)
      Response.new(response).parse
    end

    private

    def base_path
      'contact'
    end
  end
end
