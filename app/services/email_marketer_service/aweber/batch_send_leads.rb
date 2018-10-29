module EmailMarketerService
  module Aweber
    class BatchSendLeads
      attr_reader :emails, :processed_emails

      def initialize(emails)
        @auth_services = {}
        @endpoints = {}
        @emails = emails
        @processed_emails = []
      end

      def call
        accounts.each do |account|
          client = auth_service_for(account)
          account.aweber_lists.each do |list|
            emails.each do |email|
              begin
                endpoint = endpoint_for(client, list)&.subscribers
                next unless endpoint
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
        AweberAccount.all.includes(:aweber_lists)
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
        return @endpoints[list.list_id] if defined?(@endpoints[list.list_id])
        @endpoints[list.list_id] = client.aweber.account.lists[list.list_id]
      rescue AWeber::NotFoundError
        nil
      end
    end
  end
end
