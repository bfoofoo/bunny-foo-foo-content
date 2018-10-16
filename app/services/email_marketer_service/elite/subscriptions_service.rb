module EmailMarketerService
  module Elite
    class SubscriptionsService
      attr_reader :group, :params

      def initialize(group: nil, params: nil)
        @group = group
        @params = params
      end

      def add_contact(user)
        begin
          user_name = user.try(:full_name).blank? ? user.try(:name) : user.full_name
          if is_valid?(user)
            client.add_list_contact(group.list_id, {
              contact_email: user.email,
              is_double_opt_in: 0,
              contact_name: user_name,
              **params
            })
            handle_user_record(user)
          end
        rescue ::Elite::Errors::Error => e
          puts "Elite adding subscriber error - #{e}".red
        end
      end

      private

      def handle_user_record(user)
        EliteListUser.find_or_create_by(group: group, linkable: user) if user.is_a?(ActiveRecord::Base)
      end

      def is_valid?(user)
        if user.is_a?(ActiveRecord::Base)
          !EliteListUser.where(group: group, linkable: user).exists?
        else
          true
        end
      end

      def client
        @client ||= ::Elite::Client.new(account.api_key)
      end

      def account
        @account ||= group.elite_account
      end
    end
  end
end
