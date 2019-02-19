module EmailMarketerService
  module Mailigen
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
            lid =  list.campaign_id
            merge_params = create_params(user)
            response = add_to_list(lid, merge_params)
            handle_user_record(user) if response
          end
        rescue  => e
          puts "Mailigen error - #{e}".red
        end
      end
   
    def create_params(data)
      {
        'EMAIL' => data[:email],
        'FNAME' => data[:first_name],
        'LNAME' => data[:last_name],
      }
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

      def add_to_list(list_id, params)
      remail = params["EMAIL"]
      client.call :listSubscribe, {id: list_id, email_address: remail, merge_vars: params , double_optin: false }
    end

      
      def client
        return @client if defined?(@client)
        @client = ::Mailigen::Api.new(list.account.api_key)
      end
      
      def account
        @account ||= list.mailigen_account
      end
    end
  end
end
