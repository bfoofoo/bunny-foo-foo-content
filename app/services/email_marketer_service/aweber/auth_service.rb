module EmailMarketerService
  module Aweber
    class AuthService
      include Rails.application.routes.url_helpers
      attr_reader :access_token, :secret_token, :session
      
      def initialize(access_token:nil, secret_token:nil, session:{})
        @access_token = access_token
        @secret_token = secret_token
        @session = session

        handle_token_auth()
      end

      def aweber 
        # Use this method only after oAuth process
        # authorize_with_verifier(code) OR authorize_with_access(access_token, secret_token)
        AWeber::Base.new(oauth)
      end
      def authorize_url
        request_token = oauth.request_token(:oauth_callback => callbacks_aweber_auth_account_url)
        session[:aweber_oauth_token_secret] = request_token.secret
        return request_token.authorize_url
      end

      def oauth
        return @oauth if !@oauth.blank?
        @oauth = AWeber::OAuth.new(ENV["AWEBER_CONSUMER_KEY"], ENV["AWEBER_SECRET_KEY"])
      end

      def authorize_with_verifier(code, oauth_token=nil)
        oauth.request_token = OAuth::RequestToken.from_hash(
          oauth.consumer,
          oauth_token: oauth_token,
          oauth_token_secret: session[:aweber_oauth_token_secret],
        )
        oauth.authorize_with_verifier(code)
      end

      def authorize_with_access(access_token, secret_token)
        oauth.authorize_with_access(access_token, secret_token)
      end

      private 
        def handle_token_auth
          if !access_token.blank? && !secret_token.blank?
            authorize_with_access(access_token, secret_token)
          end
        end
    end
  end
end
