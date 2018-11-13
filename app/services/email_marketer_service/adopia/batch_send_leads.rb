module EmailMarketerService
  module Adopia
    class BatchSendLeads
      attr_reader :data, :processed_emails

      BATCH_SIZE = 50.freeze

      def initialize(data, account_name = nil, list_name = nil)
        @clients = {}
        @data = data
        @account_name = account_name
        @list_name = list_name
        @processed_emails = []
      end

      def call
        accounts.each do |account|
          client = client_for(account)
          data.each_slice(BATCH_SIZE) do |slice|
            begin
              client.add_list_contacts(selected_list_ids(account), {
                  contacts: build_contacts(slice),
                  is_double_opt_in: 0
              })
              @processed_emails << slice
              sleep 0.6 # to send maximum 100 per minute
            rescue ::Adopia::Errors::Error => e
              puts "Adopia adding subscriber error - #{e}".red
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

      def build_contacts(slice)
        slice.map do |item|
          item.is_a?(Hash) ? item : { contact_email: item }
        end
      end

      def selected_list_ids(account)
        return account.lists.pluck(:list_id) unless @list_name
        [account.lists.find_by(name: @list_name)&.list_id]
      end
    end
  end
end
