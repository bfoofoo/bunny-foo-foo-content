module Onepoint
  class Contact < Resource
    def create(params)
      retries ||= 0
      response = @request.post(nil, params.compact)
      Response.new(response).parse
    rescue Net::ReadTimeout
      retries += 1
      retry if retries < 3
    end

    private

    def base_path
      'contact'
    end
  end
end
