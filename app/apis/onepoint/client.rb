module Onepoint
  class Client
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def lists
      @lists ||= Lists.new(api_key)
    end

    def contact
      @contact ||= Contact.new(api_key)
    end

    def contacts
      @contacts ||= Contacts.new(api_key)
    end
  end
end
