module Ongage
  class Request
    include HTTParty

    attr_reader :base_path, :auth_headers

    API_ENDPOINT = 'https://api.ongage.net/api'.freeze

    base_uri API_ENDPOINT

    def initialize(auth_headers, base_path = nil)
      @auth_headers = auth_headers
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
        path
      ].compact.join('/')
    end

    def payload(params = {})
      {
        headers: {
          'Content-Type' => 'application/json',
        }.merge(auth_headers),
        body: params.empty? ? nil : params.to_json
      }.compact
    end
  end
end
