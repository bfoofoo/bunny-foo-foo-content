module EmailMarketerService
  module Ongage
    class SubscriptionService
      attr_reader :list, :params

      def initialize(list, params: nil)
        @list = list
        @params = params
      end

      def add_contact(user)
        begin
          if is_valid?(user)
            client.contacts.create({
              email: user.email,
              first_name: user.try(:first_name),
              last_name: user.try(:last_name),
              **params
            }, list.list_id)
            handle_user_record(user)
          end
        rescue ::Ongage::Errors::Error => e
          puts "Ongage adding subscriber error - #{e}".red
        end
      end

      private

      def handle_user_record(user)
        EspListUsers::Ongage.find_or_create_by(list: list, linkable: user) if user.is_a?(ActiveRecord::Base)
      end

      def is_valid?(user)
        if user.is_a?(ActiveRecord::Base)
          !EspListUsers::Ongage.where(list: list, linkable: user).exists?
        else
          true
        end
      end

      def client
        @client ||= ::Ongage::Client.new(account.username, account.password, account.account_code)
      end

      def account
        @account ||= list.ongage_account
      end
    end
  end
end
