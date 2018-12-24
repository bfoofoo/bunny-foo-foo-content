module Sms
  module Abstractsolutions
    class CaseSensitiveString < String
      def downcase
        self
      end

      def capitalize
        self
      end

      def to_s
        self
      end
    end

    class ApiWrapperService
      API_PATH = "https://app.abstractsolutions.net/exlapiservice/member/create"
      NL_PATH = "https://app.abstractsolutions.net/exlapi/sms/networklookup"
      LOGIN_PATH =  "https://app.abstractsolutions.net/exlapiservice/users/login"
      AUTH_HEADER_KEY = "user_key"
      AUTH_KEY_TYPE = "api-key"

      attr_reader :params, :account

      def initialize(account:nil, params:{})
        @params = params
        @account = account
      end

      def create_contact(params={})
        params = params.merge(auth_headers)
        HTTParty.post(API_PATH, body: params, :headers => {CaseSensitiveString.new("apikey") => ENV['ABSTRACTSOLUTIONS_API_KEY'],"Content-Type" => "application/x-www-form-urlencoded"})

      end

      def login(username, password)
        params = {username: username, password: password}
        HTTParty.post(LOGIN_PATH, body: params, :headers => {CaseSensitiveString.new("apikey") => ENV['ABSTRACTSOLUTIONS_API_KEY'],"Content-Type" => "application/x-www-form-urlencoded"})
      end

      def lookup_provider(params, count = 0)
        nparams = { data: params.merge(auth_headers) }
        resp = HTTParty.post(NL_PATH, body: nparams.to_json, :headers => {CaseSensitiveString.new("apikey") => ENV['ABSTRACTSOLUTIONS_API_KEY'],"Content-Type" => "application/json" })
        if resp.success?
          bresp = JSON.parse(resp.body)
          bresp["result"].last["carrier"]
        else
          newcount = count + 1
          return -1 if count > 3
          lookup_provider(params, newcount)
        end
      end

      private

      def uri(path)
        "#{API_PATH}#{path}"
      end

      def auth_headers
        {
          "#{AUTH_HEADER_KEY}": ENV['ABSTRACTSOLUTIONS_USER_KEY'],
          "client_id": ENV['ABSTRACTSOLUTIONS_CLIENT_ID']
        }
      end
    end
  end
end
