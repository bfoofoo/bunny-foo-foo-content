module Adopia
  class Request
    include HTTParty

    attr_reader :api_key

    API_ENDPOINT = 'http://www.adopia.com/services/'.freeze

    base_uri API_ENDPOINT

    def initialize(api_key)
      @api_key = api_key
    end

    def post(path, params={})
      self.class.post(uri(path), payload(params, true))
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

    def payload(params, json = false)
      return { body: default_query_params.merge(params) } if json
      { query: default_query_params.merge(params).to_query }
    end
  end
end
