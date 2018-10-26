module EmailMarketerService
  module Elite
    class FetchGroups
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
        groups.map do |group|
          account.groups.find_or_create_by(
            group_id: group.group_id,
          ).update(name: group.name)
        end
      end

      private

      def groups
        client.contact.get_interest_groups
      end

      def client
        return @client if defined?(@client)
        @client = ::Elite::Client.new(account.api_key)
      end
    end
  end
end
