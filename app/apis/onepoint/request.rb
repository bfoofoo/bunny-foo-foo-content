module Onepoint
  class Request
    include HTTParty

    attr_reader :base_path, :api_key

    API_ENDPOINT = 'https://api2.1pointinteractive.com/api'.freeze

    base_uri API_ENDPOINT

    def initialize(api_key, base_path = nil)
      @api_key = api_key
      @base_path = base_path
    end

    def post(path, params={})
      self.class.post(uri(path), payload(params))
    end

    def get(path, params={})
      self.class.get([uri(path), params.to_query].join('?'), payload)
    end

    def put(path, params={})
      self.class.put(uri(path), payload(params))
    end

    def delete(path, params={})
      self.class.delete(uri(path), payload(params))
    end

    private

    def uri(path)
      [
        API_ENDPOINT,
        base_path,
        path,
        'Api_Key',
        api_key
      ].compact.join('/')
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
