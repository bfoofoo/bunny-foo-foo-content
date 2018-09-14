module EmailMarketerService
  module Aweber
    class BatchRemoveSubscribers
      attr_reader :emails, :removed_emails

      def initialize(emails = [])
        @auth_services = {}
        @emails = emails
        @removed_emails = []
      end

      def call
        accounts.each do |account|
          endpoint = auth_service_for(account).aweber.account
          emails.each { |email| remove_subscriber(endpoint, email) }
        end
      end

      private

      def remove_subscriber(endpoint, email)
        subscribers = endpoint.find_subscribers('email' => email)&.entries&.values.to_a
        subscribers.each do |subscriber|
          subscriber.delete
        end
        @removed_emails << email
      rescue AWeber::ServiceUnavailableError, AWeber::UnknownRequestError, AWeber::NotFoundError => e
        puts "Aweber failed due to error: #{e.to_s}"
      rescue AWeber::RateLimitError
        sleep 60
        retry
      end

      def accounts
        @accounts ||= AweberAccount.all
      end

      def auth_service_for(account)
        id = account.account_id
        return @auth_services[id] if @auth_services[id].present?
        @auth_services[id] = AuthService.new(
          access_token: account.access_token,
          secret_token: account.secret_token,
        )
      end
    end
  end
end
