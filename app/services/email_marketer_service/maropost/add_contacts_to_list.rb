module EmailMarketerService
  module Maropost
    class AddContactsToList
      attr_reader :list

      def initialize(list: nil)
        @list = list
      end

      # TODO update maropost_api gem to add contacts directly to list on creation
      def add(user)
        client.contacts.create(params: {
            email: user.email,
            first_name: user.first_name,
            last_name: user.last_name
        })
        client.contacts.add_to_list(list_ids: list.list_id, params: { email: user.email })
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

    end
  end
end
