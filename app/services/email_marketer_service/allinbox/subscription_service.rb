module EmailMarketerService
  module Allinbox
    class SubscriptionService
      attr_reader :list, :params

      def initialize(list, params: nil, esp_rule: nil)
        @list = list
        @params = params
        @esp_rule = esp_rule
      end

      def add(user)
        begin
          if is_valid?(user)
            puts user
            client.contact.create( {
              email: user.email,
              first_name: user.try(:first_name),
              last_name: user.try(:last_name),
              api_key: account.api_key,
              ip: user.try(:ip),
              list_id: list.list_id
            })
            handle_user_record(user)
          end
        rescue ::Allinbox::Errors::Error => e
          puts "error - #{e}".red
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
        @client ||= ::Allinbox::Client.new(account.api_key)
      end

      def account
        @account ||= list.allinbox_account
      end

    end
  end
end
