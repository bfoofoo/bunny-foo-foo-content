module Onepoint
  class Contact < Resource
    def create(params)
      with_retry do
        response = @request.post(nil, params.compact)
        Response.new(response).parse
      end
    end

    def get_by_email(email, get_details = false)
      with_retry do
        response = @request.get("email/#{CGI.escape(email)}", { 'GetDetails' => get_details })
        Response.new(response).parse
      end
    end

    def update_by_email(params)
      with_retry do
        response = @request.put('email', params.compact)
        Response.new(response).parse
      end
    end

    private

    def base_path
      'contact'
    end
  end
end
