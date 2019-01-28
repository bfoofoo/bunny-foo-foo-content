module Onepoint
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

      if body['status'] == 'error'
        raise Errors::BadRequestError.new, body['Message']
      end
      body
    end

    def parse_collection
      multibody
    end

    private

    def body
      JSON.parse(response.body).with_indifferent_access
    rescue JSON::ParserError
      {}
    end

    def multibody
      JSON.parse(response.body).map(&:with_indifferent_access)
    rescue JSON::ParserError
      []
    end
  end
end
