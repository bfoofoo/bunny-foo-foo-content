module EmailMarketerService
  module Sparkpost
    class SubscriptionService
      attr_reader :list, :params

      def initialize(list, params: {}, esp_rule: nil)
        @list = list
        @params = params
        @esp_rule = esp_rule
      end

      def add_recipient(user)
        begin
          if is_valid?(user)
            response = client.recipient_lists.update(list.list_id, recipients: existing_recipients_for(list.list_id).concat([build_recipient(user)]))
            handle_user_record(user) if response['total_rejected_recipients'] == 0
          end
        rescue SimpleSpark::Exceptions::Error => e
          puts "Sparkpost adding subscriber error - #{e}".red
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

      def existing_recipients_for(list_id)
        list = client.recipient_lists.retrieve(list_id, true)
        recipients = list['recipients'].to_a
        recipients.map do |r|
          r.except('return_path')
        end
      end

      def client
        return @client if defined?(@client)
        @client = SimpleSpark::Client.new(api_key: account.api_key)
      end

      def account
        @account ||= list.account
      end

      def build_recipient(user)
        user_name = user.try(:full_name).blank? ? user.try(:name) : user.full_name
        {
            address: {
                email: user.email,
                name: user_name
            },
            metadata: {
                affiliate: params[:affiliate]
            }
        }
      end
    end
  end
end
