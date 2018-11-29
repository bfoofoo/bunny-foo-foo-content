module Bff
  class Request
    include HTTParty

    API_ENDPOINT = "#{SITE_HOST}/api/v1/".freeze

    base_uri API_ENDPOINT

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
