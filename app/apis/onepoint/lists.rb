module Onepoint
  class Lists < Resource
    def all(params = {})
      response = @request.get(nil, params)
      Response.new(response).parse
    end

    def add_emails(list_id, *emails)
      with_retry do
        params = emails.map do |email|
          { 'EmailAddress' => email }
        end
        response = @request.put("#{list_id}/Emails", params)
        Response.new(response).parse_collection
      end
    end

    private

    def base_path
      'lists'
    end
  end
end
