module Sms
  module Yodel
    class ApiWrapperService
      API_PATH = "http://yodel.tp.heliosmedia.me:3103/api/stream_lead_post"

      attr_reader :params, :account
      def initialize(account:nil, params:{})
        @params = params
        @account = account
      end

      def create_contact(params={})
        params = params.merge(auth)
        HTTParty.post(API_PATH, body: params)
      end

      private

      def uri path
        "#{API_PATH}#{path}"
      end

      def auth
        {
          lead_group_id: 2611
        }
      end

      

    end
  end
end
