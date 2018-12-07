module Onepoint
  class Contact < Resource
    def create(params)
      response = @request.post(nil, create_params(params))
      Response.new(response).parse
    end

    private

    def base_path
      'contact'
    end

    def create_params(data)
      params = {
        'EmailAddress' => data[:email],
        'FirstName' => data[:first_name],
        'LastName' => data[:last_name],
        'ListId' => data[:list_id],
      }
      if data[:affiliate]
        params['CustomFields'] = [
          {
            'CustomFieldName' => 'Affiliate',
            'CustomFieldValue' => data[:affiliate]
          }
        ]
      end
      params
    end
  end
end
