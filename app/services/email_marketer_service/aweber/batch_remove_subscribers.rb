module EmailMarketerService
  module Aweber
    class BatchRemoveSubscribers
      attr_reader :emails, :removed_emails

      def initialize(emails = [], list_ids: [])
        @auth_services = {}
        @emails = emails
        @removed_emails = []
        @list_ids = list_ids
        @account = nil
      end

      def call
        accounts.each do |account|
          @account = account
          endpoint = auth_service_for(account).aweber.account
          emails.each { |email| remove_subscriber(endpoint, email) }
        end
      end

      private

      def remove_subscriber(endpoint, email)
        subscribers(endpoint, email).each do |subscriber|
          subscriber.delete
        end
        @removed_emails << email
      rescue AWeber::ServiceUnavailableError, AWeber::UnknownRequestError, AWeber::NotFoundError => e
        puts "Aweber failed due to error: #{e.to_s}"
      rescue AWeber::RateLimitError
        sleep 60
        retry
      end

      def subscribers(endpoint, email)
        if included_lists.empty?
          endpoint.find_subscribers('email' => email)&.entries&.values.to_a
        else
          included_lists_for_account.map do |list|
            endpoint.lists[list.list_id].find('email' => email)&.entries&.values.to_a
          end.flatten.compact
        end
      end

      def included_lists
        return [] if @list_ids.empty?
        @included_lists ||= AweberList.where(list_id: @list_ids)
      end

      def included_lists_for_account
        included_lists.where(aweber_account_id: @account.id)
      end

      def accounts
        return @accounts if defined?(@accounts)
        @accounts = included_lists.empty? ? AweberAccount.all : AweberAccount.where(id: included_lists.pluck(:aweber_account_id))
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
