module Ongage
  class Client
    attr_reader :auth_headers

    def initialize(username, password, account_code)
      @auth_headers = {
        'X_USERNAME' => username,
        'X_PASSWORD' => password,
        'X_ACCOUNT_CODE' => account_code
      }
    end

    def lists
      @lists ||= Lists.new(auth_headers)
    end

    def contacts
      @contacts ||= Contacts.new(auth_headers)
    end
  end
end
