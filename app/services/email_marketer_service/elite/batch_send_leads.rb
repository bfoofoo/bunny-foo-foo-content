module EmailMarketerService
  module Adopia
    class BatchSendLeads
      attr_reader :emails

      BATCH_SIZE = 50.freeze

      def initialize(emails)
        @clients = {}
        @emails = emails
      end

      def call
        accounts.each do |account|
          client = client_for(account)
          emails.each_slice(50) do |slice|
            begin
              client.contact.create_contacts(
                {
                  'GroupsToAddToIds' => account.elite_groups.pluck(:group_id)
                },
                slice.map do |email|
                  {
                    'EmailAddress' => email
                  }
                end
              )
              sleep 1 # avoid api abusing
            rescue ::Elite::Errors::Error => e
              puts "Elite adding subscriber error - #{e}".red
            end
          end
        end
      end

      private

      def accounts
        EliteAccount.all.includes(:elite_groups)
      end

      def client_for(account)
        @clients[account.id] ||= ::Elite::Client.new(account.api_key)
      end
    end
  end
end
