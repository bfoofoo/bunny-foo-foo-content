module Colossus
  class LeadImport < Resource
    def create(params)
      response = @request.post("leadimport.php", create_params(params))
      Response.new(response).parse
    end

    private

    def base_path
      'leadimport.php'
    end

    def create_params(data)
      params = {
        'email' => data[:email],
        'fname' => data[:first_name],
        'lname' => data[:last_name],
        'list_id' => data[:list_id],
        'api_key' => data[:api_key],
        'state' => data[:state],
        'phone' => data[:phone], 
        'ip' => data[:ip]       
       }
      params
    end
  end
end
