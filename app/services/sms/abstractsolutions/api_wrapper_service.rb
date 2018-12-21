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

      AUTH_HEADER_KEY = "user_key"
      AUTH_KEY_TYPE = "api-key"
      APIKEY = "f50e29109ab2be1e0402d3e00a870be2"
      CLIENTID = "6198"
      attr_reader :params, :account

      def initialize(account:nil, params:{})
        @params = params
        @account = account
      end

      def create_contact(params={})
        params = params.merge(auth_headers)
        #params2 = { username: "abstract", password: "bunnylabs401"}
        HTTParty.post(API_PATH, body: params, :headers => {CaseSensitiveString.new("apikey") => "c93aca05269ece2b4eebc31b69c4ba55","Content-Type" => "application/x-www-form-urlencoded"})
       
      end

      def lookup_provider(params,count)
        nparams = params.merge(auth_headers)
        p2 = {}
        p3 = p2.merge(data: nparams )
        if( count > 3)
          carrier = -1
          return carrier 
        end
        #params2 = { username: "abstract", password: "bunnylabs401"}
        resp = HTTParty.post(NL_PATH, body: p3.to_json, :headers => {CaseSensitiveString.new("apikey") => "c93aca05269ece2b4eebc31b69c4ba55","Content-Type" => "application/json" })
        if( resp.success?)
          
          bresp = JSON.parse(resp.body)
          carrier =  bresp["result"].last["carrier"]
        else
          newcount = count+1
          lookup_provider(params,newcount)
        end
        return carrier
        
       
      end


      
      private

      def uri path
        return "#{API_PATH}#{path}"
      end

      def auth_headers
        return {
          "#{AUTH_HEADER_KEY}": APIKEY,
          "client_id": CLIENTID      
        }
      end



    end
  end
end
