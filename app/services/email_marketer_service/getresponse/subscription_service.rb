module EmailMarketerService
  module Getresponse
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
            body_params = {
              name: user.full_name,
              email: user.email,
              customFieldValues: generate_custom_field_array(),
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

      def generate_custom_field_array params
        response =  [
          {
            "customFieldId" => Getresponse::ApiWrapperService::CUSTOM_FIELDS["method"],
            "value" => ["Webform"]
          }
        ]
        if !params[:url].blank?
          response << {
            "customFieldId" => Getresponse::ApiWrapperService::CUSTOM_FIELDS["url"],
            "value" => [params[:url]]
          }
        end
        return response
      end

      def handle_user_record(user)
        ExportedLead.find_or_create_by(list: list, linkable: user).update(esp_rule: @esp_rule) if user.is_a?(ActiveRecord::Base)
      end

      def is_valid?(user)
        if user.is_a?(ActiveRecord::Base)
          !ExportedLead.where(list: list, linkable: user).exists?
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
