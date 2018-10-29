module EmailMarketerService
  module Adopia
    class BatchSendLeads
      attr_reader :emails, :processed_emails

      BATCH_SIZE = 50.freeze

      def initialize(emails)
        @clients = {}
        @emails = emails
        @account = nil
        @processed_emails = []
      end

      def call
        accounts.each do |account|
          client = client_for(account)
          account.lists.each do |list|
            emails.each do |email|
              begin
                client.add_list_contact(list.list_id, {
                  contact_email: email,
                  is_double_opt_in: 0
                })
                @processed_emails << email
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
        AdopiaAccount.all.includes(:adopia_lists)
      end

      def client_for(account)
        @clients[account.id] ||= ::Adopia::Client.new(account.api_key)
      end
    end
  end
end
