module AweberInteractor
  class UpsertAccount
    include Interactor

    delegate :params, :auth_service,  :to => :context

    def call
      context.message = ""
      context.fail! if oauth_token.blank? || oauth_verifier.blank?
      upsert_account()
    end

    private   
      def upsert_account
        account = AweberAccount.find_or_initialize_by(account_id: aweber_account.id ) do |account|
          account.access_token = access_token
          account.secret_token = access_token_secret
          account.oauth_token = oauth_token
        end
        if account.save
          context.access_token = access_token
          context.access_token_secret = access_token_secret
          context.account_id = account.id
          context.message = "Account was successfully added."
        else
          context.message = account.errors.first
          context.fail!
        end
      end

      def auth_service
        return @auth_service if !@auth_service.blank?
        begin
          context.auth_service = EmailMarketerService::Aweber::AuthService.new(session: context.session)
          context.auth_service.authorize_with_verifier(oauth_verifier, oauth_token)
          @auth_service = context.auth_service
        rescue => e
          context.message = "Can't authorize Aweber account."
          context.fail!
        end
      end

      def access_token
        return @access_token if !@access_token.blank?
        @access_token = auth_service.oauth.access_token.token
      end

      def access_token_secret
        return @access_token_secret if !@access_token_secret.blank?
        @access_token_secret = auth_service.oauth.access_token.secret
      end

      def aweber_account
        auth_service.aweber.account
      end

      def oauth_token
        params["oauth_token"]
      end

      def oauth_verifier
        params["oauth_verifier"]
      end
  end
end
