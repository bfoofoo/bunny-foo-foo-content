module Elite
  class Request
    include HTTParty

    attr_reader :api_key, :base_path

    API_ENDPOINT = 'https://api.eliteemail.net'.freeze

    base_uri API_ENDPOINT

    def initialize(api_key, base_path = nil)
      @api_key = api_key
      @base_path = base_path
    end

    def post(path, params={})
      self.class.post(uri(path), payload(params))
    end

    private

    def default_query_params
      {
        'Token' => api_key
      }
    end

    def uri(path)
      [
        API_ENDPOINT,
        base_path,
        path
      ].compact.join('/')
    end

    def payload(params)
      {
        headers: { 'Content-Type' => 'application/json' },
        body: default_query_params.merge(params).to_json
      }
    end
  end
end
