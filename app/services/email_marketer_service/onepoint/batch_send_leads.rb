module EmailMarketerService
  module Onepoint
    class BatchSendLeads
      attr_reader :emails, :processed_emails

      BATCH_SIZE = 500.freeze

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
                client.post(endpoint_for(list), {
                  members: slice.to_json
                })
                @processed_emails.concat(emails)
                sleep 0.2 # avoid api abusing
              rescue ::Onepoint::Error => e
                puts "Onepoint adding members error - #{e}".red
              end
            end
          end
        end
      end

      private

      def accounts
        MailgunAccount.all.includes(:mailgun_lists)
      end

      def client_for(account)
        @clients[account.id] ||= ::Onepoint::Client.new(account.api_key)
      end

      def endpoint_for(list)
        "/lists/#{list.address}/members.json"
      end
    end
  end
end
