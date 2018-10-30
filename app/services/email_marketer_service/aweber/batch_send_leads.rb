module EmailMarketerService
  module Aweber
    class BatchSendLeads
      attr_reader :emails, :processed_emails

      def initialize(emails, account_id)
        @auth_services = {}
        @endpoints = {}
        @emails = emails
        @account_id = account_id
        @processed_emails = []
      end

      def call
        accounts.each do |account|
          client = auth_service_for(account)
          account.aweber_lists.each do |list|
            endpoint = endpoint_for(client, list)&.subscribers
            next unless endpoint
            emails.each do |email|
              begin
                endpoint.create("email" => email)
                @processed_emails << email
                sleep 0.6
              rescue AWeber::RateLimitError
                sleep 60
                retry
              rescue AWeber::CreationError => e
                puts "Aweber adding subscriber error - #{e}".red
              end
            end
          end
        end
      end

      private

      def accounts
        query = AweberAccount.all.includes(:aweber_lists)
        query = query.where(account_id: @account_id) if @account_id
        query
      end

      def auth_service_for(aweber_account)
        id = aweber_account.account_id
        return @auth_services[id] if @auth_services[id].present?
        @auth_services[id] = EmailMarketerService::Aweber::AuthService.new(
          access_token: aweber_account.access_token,
          secret_token: aweber_account.secret_token,
          )
      end

      def endpoint_for(client, list)
        @endpoints[list.list_id] ||= client.aweber.account.lists[list.list_id]
      rescue AWeber::NotFoundError
        nil
      end
    end
  end
end
