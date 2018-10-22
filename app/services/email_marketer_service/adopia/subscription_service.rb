module EmailMarketerService
  module Adopia
    class SubscriptionService
      attr_reader :list, :params

      def initialize(list, params: nil)
        @list = list
        @params = params
      end

      def add_contact(user)
        begin
          user_name = user.try(:full_name).blank? ? user.try(:name) : user.full_name
          if is_valid?(user)
            client.add_list_contact(list.list_id, {
              contact_email: user.email,
              is_double_opt_in: 0,
              contact_name: user_name,
              **params
            })
            handle_user_record(user)
          end
        rescue ::Adopia::Errors::Error => e
          puts "Adopia adding subscriber error - #{e}".red
        end
      end

      private

      def handle_user_record(user)
        EspListUsers::Adopia.find_or_create_by(list: list, linkable: user) if user.is_a?(ActiveRecord::Base)
      end

      def is_valid?(user)
        if user.is_a?(ActiveRecord::Base)
          !EspListUsers::Adopia.where(list: list, linkable: user).exists?
        else
          true
        end
      end

      def client
        @client ||= ::Adopia::Client.new(account.api_key)
      end

      def account
        @account ||= list.adopia_account
      end
    end
  end
end
