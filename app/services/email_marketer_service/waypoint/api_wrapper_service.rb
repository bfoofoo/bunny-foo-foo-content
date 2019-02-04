module EmailMarketerService
    module Waypoint
      class ApiWrapperService
        API_PATH = "https://bluemodo.waypointsoftware.com/capture.php"
  
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
      end
    end
  end