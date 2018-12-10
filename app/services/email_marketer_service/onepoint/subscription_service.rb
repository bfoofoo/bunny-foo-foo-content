module EmailMarketerService
  module Onepoint
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
            client.contact.create(contact_params_for(user))
            handle_user_record(user)
          end
        rescue ::Onepoint::Errors::Error => e
          handle_user_record(user) if e.message == "email: Subscriber already subscribed."
          puts "Onepoint adding subscriber error - #{e}".red
        end
      end

      private

      def contact_params_for(user)
        hash = {
          'EmailAddress' => user.email,
          'FirstName' => user.try(:first_name) || user.full_name&.split(' ')&.first,
          'LastName' => user.try(:last_name) || user.full_name&.split(' ')&.last,
          'ListId' => list.list_id,
          'casl_ipaddress' => params[:ip],
          'casl_signupdate' => params[:date].strftime('%m/%d/%Y'),
          'casl_signup_method' => params[:signup_method],
          'casl_signup_url' => params[:url],
          'State' => params[:state]
        }

        if params[:affiliate]
          hash['CustomFields'] = [
            {
              'CustomFieldName' => 'Affiliate',
              'CustomFieldValue' => params[:affiliate]
            }
          ]
        end
        hash
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
        @client ||= ::Onepoint::Client.new(account.api_key)
      end

      def account
        @account ||= list.onepoint_account
      end

    end
  end
end
