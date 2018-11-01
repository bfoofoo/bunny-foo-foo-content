module EmailMarketerService
  module Netatlantic
    class BatchSendLeads < BaseService
      attr_reader :emails, :processed_emails

      BATCH_SIZE = 300.freeze

      def initialize(emails, account_name = nil)
        @emails = emails
        @account_name = account_name
        @processed_emails = []
      end

      def call
        accounts.each do |account|
          account.netatlantic_lists.each do |list|
            emails.each_slice(BATCH_SIZE) do |slice|
              add_members(slice, account, list)
              @processed_emails << slice
            end
          end
        end
      end

      private

      def accounts
        query = NetatlanticAccount.all.includes(:netatlantic_lists)
        query = query.where(account_name: @account_name) if @account_name
        query
      end

      def add_members(emails, account, list)
        members = emails.map { |email| { 'EmailAddress' => email, 'FullName' => '' } }
        HTTParty.post("#{API_PATH}/create_members.php", body: { members: members, account: account.account_name, list: list.name }.compact)
      end
    end
  end
end
