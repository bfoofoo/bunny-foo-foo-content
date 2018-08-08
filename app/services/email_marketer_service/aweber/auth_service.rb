require 'aweber'
module EmailMarketerService
  module Aweber
    class AuthService
      include Rails.application.routes.url_helpers
      attr_reader :access_token, :secret_token
      
      def initialize(access_token:nil, secret_token:nil)
        @access_token = access_token
        @secret_token = secret_token
        handle_token_auth()
      end

      def aweber 
        AWeber::Base.new(oauth)
      end

      def authorize_url
        # (:oauth_callback => callbacks_aweber_test_url)
        oauth.request_token.authorize_url
      end

      def oauth
        return @oauth if !@oauth.blank?
        @oauth = AWeber::OAuth.new(ENV["AWEBER_CONSUMER_KEY"], ENV["AWEBER_SECRET_KEY"])
      end

      def authorize_with_verifier(code)
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