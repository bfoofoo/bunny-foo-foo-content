module EmailMarketerService
  module Colossus
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
            custom_fields = COLOSSUS_CUSTOM_FIELDS.each_with_object({}) { |cf, memo| memo[cf] = params[cf] }
            request_params = {
              email: user.email,
              first_name: user.try(:first_name),
              last_name: user.try(:last_name),
              api_key: account.api_key,
              ip: params.try(:fetch, :ip),
              list_id: list.list_id,
              phone: params[:phone],
              state: params[:state],
              url: params[:url],
              date: params[:date],
              **custom_fields
            }
            response = client.create_contact(request_params)
            if response&.body != 'Success'
              raise ::Colossus::Errors::BadRequestError, response&.body
            end
            handle_user_record(user)
          end
        rescue ::Colossus::Errors::Error => e
          puts "Colossus error - #{e}".red
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
        @client ||= ::Colossus::Client.new(account.api_key)
      end

      def account
        @account ||= list.colossus_account
      end
    end
  end
end
