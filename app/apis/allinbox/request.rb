module Allinbox
  class Request
    include HTTParty
    attr_reader :api_key

    API_ENDPOINT = 'https://api2.all-inbox.com/?resource='.freeze

    base_uri API_ENDPOINT

    def initialize(api_key)
      @api_key = api_key
    end

    
    def post(path, params={})
      self.class.post(uri(path),:body => params, :headers => {"Content-Type" => "application/x-www-form-urlencoded"})       
    end

    def get(path, params={})
      self.class.get(uri(path), payload(params))
    end

    def put(path, params={})
      self.class.put(uri(path), payload(params))
    end

    def delete(path, params={})
      self.class.delete(uri(path), payload(params))
    end

    private

    def default_query_params
      {
          response_type: 'json',
          api_key: api_key
      }
    end

    def uri(path)
      "#{API_ENDPOINT}#{path}"
    end
    def payload(params = {})
      {
        headers: {
          'Content-Type' => 'application/json',
        },
        body: params.empty? ? nil : params.to_json
      }.compact
    end
  end
end
