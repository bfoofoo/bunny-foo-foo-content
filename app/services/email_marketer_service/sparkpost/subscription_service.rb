module EmailMarketerService
  module Sparkpost
    class SubscriptionService
      attr_reader :list, :params

      def initialize(list, params: nil, esp_rule: nil)
        @list = list
        @params = params
        @esp_rule = esp_rule
      end

      def add_recipient(user)
        begin
          if is_valid?(user)
            client.recipient_lists.update(list.list_id, recipients: existing_recipients_for(list.list_id).concat([build_recipient(user)]))
            handle_user_record(user)
          end
        rescue SimpleSpark::Exceptions::Error => e
          puts "Sparkpost adding subscriber error - #{e}".red
        end
      end

      private

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

      def existing_recipients_for(list_id)
        list = client.recipient_lists.retrieve(list_id, true)
        list['recipients'].to_a
      rescue
        []
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
            tags: [params[:affiliate]]
        }
      end
    end
  end
end
