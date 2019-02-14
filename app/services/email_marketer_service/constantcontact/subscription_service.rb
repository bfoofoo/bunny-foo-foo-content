module EmailMarketerService
  module Constantcontact
    class SubscriptionService
      attr_reader :list, :params

      def initialize(list, params: nil, esp_rule: nil)
        @list = list
        @params = params
        @esp_rule = esp_rule
      end

      def add(user)
        if is_valid?(user)
          new_contact = ConstantContact::Components::Contact.new
          new_contact.add_email(ConstantContact::Components::EmailAddress.new(user.email))
          list_to_add_to = ConstantContact::Components::ContactList.new
          list_to_add_to.id = list.list_id
          new_contact.add_list(list_to_add_to)
          new_contact.first_name = user.try(:first_name)
          new_contact.last_name = user.try(:last_name)
          client.add_contact(new_contact)
          handle_user_record(user)
        end
      rescue RestClient::BadRequest => e
        puts "#{e.http_code} - #{e.http_body}"
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
        return @client if defined?(@client)
        @client = ConstantContact::Api.new(list.account.api_key, list.account.access_token)
      end

      def account
        @account ||= list.constantcontact_account
      end
    end
  end
end
