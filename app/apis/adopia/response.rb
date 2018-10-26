module Adopia
  class Response
    attr_reader :response

    def initialize(response, type=nil)
      @response = response
      @type = type
    end

    def parse
      case response.code
      when 400
        raise Errors::BadRequestError.new, body[:message], caller
      when 401
        raise Errors::UnauthorizedError.new
      when 404
        raise Errors::NotFoundError.new
      when 500
        raise Errors::InternalServerError.new, body[:message], caller
      else
        body[:response]
      end
    end

    private

    def body
      JSON.parse(response.body).with_indifferent_access
    rescue JSON::ParserError
      {}
    end
  end
end
