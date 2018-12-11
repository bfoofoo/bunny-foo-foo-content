module EmailMarketerService
  module Getresponse
    class SubscriptionService
      attr_reader :list, :params

      def initialize(list, params: nil, esp_rule: nil)
        @list = list
        @params = params
        @esp_rule = esp_rule
      end

      def add(user)
        begin
          user_name = user.try(:full_name).blank? ? user.try(:name) : user.full_name
          if is_valid?(user)
            body_params = {
              name: user_name,
              email: user.email,
              customFieldValues: generate_custom_field_array,
              campaign: {
                "campaignId" => list.campaign_id
              },
              **params
            }
            client.create_contact(body_params.stringify_keys.to_json)
            handle_user_record(user)
          end
        rescue => e
          puts "Getresponse adding subscriber error - #{e}".red
        end
      end

      private

      def generate_custom_field_array
        response =  [
          {
            "customFieldId" => custom_field_id('method'),
            "value" => ["Webform"]
          }
        ]
        ApiWrapperService::CUSTOM_FIELDS.keys - %w(method join_date).each do |field|
          response << {
            "customFieldId" => custom_field_id(field),
            "value" => [custom_param(field)]
          } if custom_param(field).present?
        end
        response << {
          "customFieldId" => custom_field_id('join_date'),
          "value" => [custom_param('join_date').strftime('%d.%m.%Y')]
        } if custom_param('join_date').present?
        response
      end

      def custom_param(key)
        params[ApiWrapperService::CUSTOM_FIELD_MAPPING[key]]
      end

      def custom_field_id(key)
        ApiWrapperService::CUSTOM_FIELDS[key]
      end

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
        @client = EmailMarketerService::Getresponse::ApiWrapperService.new(account: account)
      end

      def account
        @account ||= list.account
      end
    end
  end
end
