module Allinbox
  class Client
    attr_reader :api_key
    def initialize(api_key)
      @api_key = api_key
    end

    def contact
      @contact ||= Contact.new(api_key)
    end
  end
end
