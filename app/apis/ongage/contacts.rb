module Ongage
  class Contacts < Resource
    def create(params, list_id = nil)
      if list_id
        response = HTTParty.post("https://api.ongage.net/#{list_id}/api/#{base_path}", {
          headers: {
            'Content-Type' => 'application/json',
          }.merge(@request.auth_headers),
          body: create_params(params).to_json
        })
      else
        response = @request.post(nil, create_params(params))
      end
      Response.new(response).parse
    end

    private

    def base_path
      'v2/contacts'
    end

    def create_params(data)
      {
        overwrite: true,
        email: data[:email],
        fields: data.except(:email)
      }
    end
  end
end
