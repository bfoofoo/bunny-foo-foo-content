module EmailMarketerService
  module Adopia
    class BatchSendLeads
      attr_reader :emails, :processed_emails

      BATCH_SIZE = 50.freeze

      def initialize(emails, account_name = nil)
        @clients = {}
        @emails = emails
        @account_name = account_name
        @processed_emails = []
      end

      def call
        accounts.each do |account|
          client = client_for(account)
          account.lists.each do |list|
            p list
            emails.each do |email|
              begin
                client.add_list_contact(list.list_id, {
                  contact_email: email,
                  is_double_opt_in: 0
                })
                @processed_emails << email
                p "sent #{email}"
                sleep 0.6 # to send maximum 100 per minute
              rescue ::Adopia::Errors::Error => e
                puts "Adopia adding subscriber error - #{e}".red
              end
            end
          end
        end
      end

      private

      def accounts
        query = AdopiaAccount.all.includes(:adopia_lists)
        query = query.where(name: @account_name) if @account_name
        query
      end

      def client_for(account)
        @clients[account.id] ||= ::Adopia::Client.new(account.api_key)
      end
    end
  end
end
