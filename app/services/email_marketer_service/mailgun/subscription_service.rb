module EmailMarketerService
  module Mailgun
    class SubscriptionService
      attr_reader :list, :params

      def initialize(list, params: nil, esp_rule: nil)
        @list = list
        @params = params
        @esp_rule = esp_rule
      end

      def add_member(user)
        begin
          user_name = user.try(:full_name).blank? ? user.try(:name) : user.full_name
          if is_valid?(user)
            client.post(members_path, {
              'address' => user.email,
              'name' => user_name,
              'vars' => { 'affiliate' => params[:affiliate] }.to_json,
              'upsert' => 'yes'
            })
            handle_user_record(user)
          end
        rescue ::Mailgun::Error => e
          handle_user_record(user) if e.message == "email: Subscriber already subscribed."
          puts "Mailgun adding subscriber error - #{e}".red
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

      def client
        @client ||= ::Mailgun::Client.new(account.api_key)
      end

      def members_path
        "/lists/#{list.address}/members"
      end

      def account
        @account ||= list.mailgun_account
      end

    end
  end
end