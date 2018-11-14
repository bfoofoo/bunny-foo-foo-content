module EmailMarketerService
  module Adopia
    class BatchSendLeads
      attr_reader :data, :processed_emails

      def initialize(data, account_name = nil, list_names = [])
        @clients = {}
        @data = data
        @account_name = account_name
        @list_names = list_names
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

      def build_contacts(slice)
        slice.map do |item|
          item.is_a?(Hash) ? item : { contact_email: item }
        end
      end

      def selected_list_ids(account)
        lists = account.lists
        lists = lists.where(name: @list_names) unless @list_names.empty?
        lists.pluck(:list_id)
      end
    end
  end
end
