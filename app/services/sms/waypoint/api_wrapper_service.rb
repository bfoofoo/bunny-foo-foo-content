module Sms
  module Waypoint
    class ApiWrapperService
      API_PATH = "https://brunettemarketing.waypointsoftware.com/capture.php"

      AUTH_HEADER_KEY = "xAuthentication"
      AUTH_KEY_TYPE = "api-key"

      attr_reader :params, :account

      def initialize(account:nil, params:{})
        @params = params
        @account = account
      end

      def create_contact(params={})
        params = params.merge(auth_headers)
        HTTParty.post(API_PATH, body: params)
      end

      private

      def uri path
        "#{API_PATH}#{path}"
      end

      def auth_headers
        {
          "#{AUTH_HEADER_KEY}": ENV["WAYPOINT_KEY"],
        }
      end


    end
  end
end
