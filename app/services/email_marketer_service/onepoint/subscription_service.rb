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
        return unless is_valid?(user)
        create_or_update_contact(user)
      rescue ::Onepoint::Errors::Error => e
        puts "Onepoint adding subscriber error - #{e}".red
      end

      private

      def create_or_update_contact(user)
        contact_exists?(user) ? add_contact_to_list(user) : create_contact(user)
        handle_user_record(user)
      end

      def contact_exists?(user)
        !!client.contact.get_by_email(user.email)
      rescue ::Onepoint::Errors::BadRequestError
        false
      end

      def create_contact(user)
        client.contact.create(contact_params_for(user))
      end

      def add_contact_to_list(user)
        client.lists.add_emails(list.list_id, user.email)
      end

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
