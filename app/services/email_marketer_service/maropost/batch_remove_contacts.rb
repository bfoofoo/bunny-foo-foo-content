module EmailMarketerService
  module Maropost
    class BatchRemoveContacts
      attr_reader :emails, :removed_emails

      def initialize(emails = [])
        @maropost_clients = {}
        @emails = emails
        @removed_emails = []
      end

      def call
        accounts.each do |account|
          emails.each { |email| delete_contact(account, email) }
        end
      end

      private

      def delete_contact(account, email)
        client_for(account).contacts.delete_all(params: { 'contact[email]' => email })
        @removed_emails << email
      rescue MaropostApi::Errors => e
        puts "Maropost contact deletion failed due to error: #{e.to_s}"
      end

      def accounts
        @accounts ||= MaropostAccount.all
      end

      def client_for(account)
        id = account.account_id
        return @maropost_clients[id] if @maropost_clients[id].present?
        @maropost_clients[id] = MaropostApi::Client.new(
          auth_token: account.auth_token,
          account_number: account.account_id
        )
      end
    end
  end
end
