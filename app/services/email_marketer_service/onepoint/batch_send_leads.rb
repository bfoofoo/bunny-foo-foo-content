module EmailMarketerService
  module Onepoint
    class BatchSendLeads
      attr_reader :emails, :processed_emails

      BATCH_SIZE = 50.freeze

      def initialize(emails)
        @clients = {}
        @emails = emails
        @processed_emails = []
      end

      def call
        accounts.each do |account|
          client = client_for(account)
          emails.each_slice(BATCH_SIZE) do |slice|
            account.lists.each do |list|
              begin
                client.contacts.create(build_contacts(slice, list))
                @processed_emails.concat(slice)
                sleep 1 # avoid api abusing
              rescue ::Onepoint::Errors::Error => e
                puts "Onepoint adding contacts error - #{e}".red
              end
            end
          end
        end
      end

      private

      def accounts
        OnepointAccount.all.includes(:onepoint_lists)
      end

      def client_for(account)
        @clients[account.id] ||= ::Onepoint::Client.new(account.api_key)
      end

      def build_contacts(emails, list)
        emails.map do |email|
          {
            'EmailAddress' => email,
            'FirstName' => '',
            'LastName' => '',
            'ListId' => list.list_id
          }
        end
      end
    end
  end
end
