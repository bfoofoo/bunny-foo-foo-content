module EmailMarketerService
  module Maropost
    class AddContactsToList
      attr_reader :list, :params

      def initialize(list:, params: {})
        @list = list
        @params = params
      end

      def add(user)
        client.contacts.create_for_list(list_id: list.list_id, params: {
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          subscribe: true,
          custom_field: {
            affiliate: params[:affiliate]
          }
        })
        handle_user(user)
        true
      rescue MaropostApi::Errors => e
        puts "Maropost has failed to add contact due to error - #{e}".red
        false
      end

      private

      def account
        list.account
      end

      def client
        return @client if defined?(@client)
        @client = MaropostApi::Client.new(auth_token: account.auth_token, account_number: account.account_id)
      end

      def handle_user(user)
        MaropostListUser.find_or_create_by(list: list, linkable: user)
      end
    end
  end
end
