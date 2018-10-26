module Elite
  class Response
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def parse
      case response.code
      when 400
        raise Errors::BadRequestError.new, body['ErrorMessages'].join(','), caller
      when 401
        raise Errors::UnauthorizedError.new
      when 404
        raise Errors::NotFoundError.new
      when 500
        raise Errors::InternalServerError.new, body['ErrorMessages'].join(','), caller
      end

      if (body['ResultMessage'] == 'error')
        raise Errors::BadRequestError, body['ErrorMessages'].join(',')
      end
      body
    end

    private

    def body
      JSON.parse(response.body).with_indifferent_access
    rescue JSON::ParserError
      {}
    end
  end
end
