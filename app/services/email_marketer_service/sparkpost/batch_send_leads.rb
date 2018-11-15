module EmailMarketerService
  module Sparkpost
    class BatchSendLeads
      attr_reader :data, :processed_emails

      def initialize(data, account_id = nil, *list_ids)
        @clients = {}
        @data = data
        @account_id = account_id
        @list_ids = list_ids
        @processed_emails = []
      end

      def call
        accounts.each do |account|
          client = client_for(account)
          selected_lists(account).each do |list|
            begin
              updated_list = existing_recipients_for(account, list.list_id).concat(build_recipients(data))
              client.recipient_lists.update(list.list_id, recipients: updated_list)
              @processed_emails.concat(data)
            rescue SimpleSpark::Exceptions::Error => e
              puts "Sparkpost adding members error - #{e}".red
            end
          end
        end
      end

      private

      def accounts
        query = SparkpostAccount.all.includes(:sparkpost_lists)
        query = query.where(account_id: @account_id) if @account_id.present?
        query
      end

      def selected_lists(account)
        lists = account.lists
        lists = lists.where(list_id: @list_ids) unless @list_ids.empty?
        lists
      end

      def client_for(account)
        @clients[account.id] ||= SimpleSpark::Client.new(api_key: account.api_key)
      end

      def existing_recipients_for(account, list_id)
        list = client_for(account).recipient_lists.retrieve(list_id, true)
        recipients = list['recipients'].to_a
        recipients.map do |r|
          r.except('return_path')
        end
      end

      def build_recipients(data)
        data.map do |item|
          if item.is_a?(Hash)
            {
              address: {
                email: item['email'],
                name: item['name']
              }
            }
          else
            {
              address: { email: item }
            }
          end
        end
      end
    end
  end
end
