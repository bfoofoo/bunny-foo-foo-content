module AweberInteractor
  class RefreshAccountLists
    include Interactor

    delegate :access_token, :access_token_secret, :account_id, :to => :context

    def call
      context.message = ""
      context.fail! if access_token.blank? || access_token_secret.blank?
      refresh_lists()
    end

    private   

      def refresh_lists
        lists.each do |list|
          account_model.aweber_lists.find_or_create_by(list_id: list[:id]) do |list_model|
            list_model.name = list[:name]
          end
        end
      end

      def auth_service
        return @auth_service if !@auth_service.blank?
        begin
          context.auth_service = EmailMarketerService::Aweber::AuthService.new(access_token: access_token, secret_token: access_token_secret)
          @auth_service = context.auth_service
        rescue => e
          context.message = "Can't authorize Aweber account."
          context.fail!
        end
      end

      def aweber_account
        @aweber_account ||= auth_service.aweber.account
      end

      def account_model
        begin
          @account_model ||= AweberAccount.find(account_id)
        rescue => e
          context.message = "Can't find Account with id: #{account_id}."
          context.fail!
        end
      end

      def lists
        @lists ||= aweber_account.lists.map {|list| {id: list[0], name:list[1].name}}
      end

  end
end
