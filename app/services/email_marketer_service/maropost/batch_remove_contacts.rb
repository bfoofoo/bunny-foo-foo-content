module EmailMarketerService
  module Maropost
    class BatchRemoveContacts
      attr_reader :emails, :removed_emails

      def initialize(emails = [], list_ids: [])
        @maropost_clients = {}
        @emails = emails
        @removed_emails = []
        @list_ids = list_ids
        @account = nil
      end

      def call
        accounts.each do |account|
          @account = account
          emails.each { |email| delete_contact(account, email) }
        end
      end

      private

      def delete_contact(account, email)
        included_lists.empty? ? delete_from_all_lists(account, email) : delete_from_included_lists(account, email)
        @removed_emails << email
      rescue MaropostApi::Errors => e
        puts "Maropost contact deletion failed due to error: #{e.to_s}"
      end

      def delete_from_all_lists(account, email)
        client_for(account).contacts.delete_all(params: { 'contact[email]' => email })
      end

      def delete_from_included_lists(account, email)
        contact = client_for(account).contacts.find_by_email(email: email)
        client_for(account).contacts.delete_from_lists(contact_id: contact['id'], list_ids: included_lists_for_account.pluck(:list_id))
      end

      def included_lists
        return [] if @list_ids.empty?
        @included_lists ||= MaropostList.where(list_id: @list_ids)
      end

      def included_lists_for_account
        included_lists.where(maropost_account_id: @account.id)
      end

      def accounts
        return @accounts if defined?(@accounts)
        @accounts = included_lists.empty? ? MaropostAccount.all : MaropostAccount.where(id: included_lists.pluck(:maropost_account_id))
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
