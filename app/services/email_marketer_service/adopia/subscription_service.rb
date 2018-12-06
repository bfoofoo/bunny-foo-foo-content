module EmailMarketerService
  module Adopia
    class SubscriptionService
      attr_reader :list, :params

      def initialize(list, params: nil, esp_rule: nil)
        @list = list
        @params = params
        @esp_rule = esp_rule
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
        ExportedLead.find_or_create_by(list_id: list.id, list_type: list.type, linkable: user).update(esp_rule: @esp_rule) if user.is_a?(ActiveRecord::Base)
      end

      def is_valid?(user)
        if user.is_a?(ActiveRecord::Base)
          !ExportedLead.where(list_id: list.id, list_type: list.type, linkable: user).exists?
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
