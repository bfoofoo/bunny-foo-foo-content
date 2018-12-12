module Allinbox
  class Contact < Resource
    def create(params)
      response = @request.post("contacts", create_params(params))
      Response.new(response).parse
    end

    private

    def base_path
      'contact'
    end

    def create_params(data)
      params = {
        'email' => data[:email],
        #'first_name' => data[:first_name],
        #'last_name' => data[:last_name],
        'source_id' => data[:list_id],
        'api_key' => data[:api_key],
        'ip_address' => data[:ip]               
       }
      params
    end
  end
end

