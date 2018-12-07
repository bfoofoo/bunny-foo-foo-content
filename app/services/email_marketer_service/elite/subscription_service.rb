module EmailMarketerService
  module Elite
    class SubscriptionService
      attr_reader :group, :params

      def initialize(group, params: nil, esp_rule: nil)
        @group = group
        @params = params
        @esp_rule = esp_rule
      end

      def add(user)
        begin
          if is_valid?(user)
            client.contact.create_contacts(
              {
                'GroupsToAddToIds' => [group.group_id]
              },
              [
                {
                  'EmailAddress' => user.email,
                  'Affiliate' => params[:affiliate],
                  'FirstName' => user.try(:first_name),
                  'LastName' => user.try(:last_name)
                }
              ]
            )
            handle_user_record(user)
          end
        rescue ::Elite::Errors::Error => e
          puts "Elite adding subscriber error - #{e}".red
        end
      end

      private

      def handle_user_record(user)
        ExportedLead.find_or_create_by(list_id: group.id, list_type: group.type, linkable: user).update(esp_rule: @esp_rule) if user.is_a?(ActiveRecord::Base)
      end

      def is_valid?(user)
        if user.is_a?(ActiveRecord::Base)
          !ExportedLead.where(list_id: group.id, list_type: group.type, linkable: user).exists?
        else
          true
        end
      end

      def client
        @client ||= ::Elite::Client.new(account.api_key)
      end

      def account
        @account ||= group.account
      end
    end
  end
end
