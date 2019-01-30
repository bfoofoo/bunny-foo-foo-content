module Allinbox
  class Response
    attr_reader :response

    def initialize(response, type=nil)
      @response = response
      @type = type
    end

    def parse
      case response.code
      when 400
        raise Errors::BadRequestError.new, body[:response], caller
      when 401
        raise Errors::UnauthorizedError.new
      when 404
        raise Errors::NotFoundError.new
      when 500
        raise Errors::InternalServerError.new, body[:response], caller
      else
        body[:response]
      end
    end

    private

    def body
      Hash.from_xml(response.body).with_indifferent_access
    rescue REXML::ParseException
      {}
    end
  end
end
