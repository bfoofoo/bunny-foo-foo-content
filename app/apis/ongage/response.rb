module Ongage
  class Response
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def parse
      case response.code
      when 400
        raise Errors::BadRequestError.new, response.body
      when 401
        raise Errors::UnauthorizedError.new
      when 404
        raise Errors::NotFoundError.new
      when 500
        raise Errors::InternalServerError.new, response.body
      end

      if is_error?
        raise Errors::BadRequestError, payload['message']
      end
      payload
    end

    private

    def body
      JSON.parse(response.body).with_indifferent_access
    rescue JSON::ParserError
      #raise Errors::BadRequestError.new, "JSON parse error: #{response.body.inspect}"
      {}
    end

    def is_error?
      response['metadata']['error']
    end

    def payload
      body['payload']
    end
  end
end
