module Sms
  module Epcvip
    class ApiWrapperService
      API_PATH = "https://www.eloanconnect.com/?cmd=LeadSubmit"

      attr_reader :params, :account
      def initialize(account:nil, params:{})
        @params = params
        @account = account
      end

      def create_contact(params={})
        params = params.merge(auth)
        puts(params)
        tes = HTTParty.post(API_PATH, body: params)
        puts(tes.response.code)
        puts(tes.response.body)
      end

      private

      def uri path
        "#{API_PATH}#{path}"
      end

      def auth
        {
         sourceId: 5018,
         apiKey: "9$75df6",
         campaignId: 5,                  
         
        }
      end

      

    end
  end
end
