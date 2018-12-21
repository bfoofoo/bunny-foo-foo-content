module EmailMarketerService
  module Netatlantic
    class BatchSendLeads < BaseService
      attr_reader :data, :processed_emails

      BATCH_SIZE = 50.freeze

      def initialize(data, *list_names)
        @data = data
        @list_names = list_names
        @processed_emails = []
      end

      def call
        selected_lists.each do |list|
          data.each_slice(BATCH_SIZE) do |slice|
            add_members_one_by_one(slice, list)
            @processed_emails.concat(slice)
          end
        end
      end

      private

      def selected_lists
        return NetatlanticList.where(name: @list_names) unless @list_names.empty?
        NetatlanticList.all
      end

      def add_members_one_by_one(data, list)
        members = data.map do |item|
          if item.is_a?(Hash)
            { 'EmailAddress' => item[:email], 'FullName' => item[:full_name], 'fields' => item[:fields] }
          else
            { 'EmailAddress' => item, 'FullName' => '' }
          end
        end

        members.each do |member|
          response = HTTParty.post("#{API_PATH}/create_member.php", body: { email: member["EmailAddress"], full_name: member["FullName"], account: list.account.account_name, list: list.name }.compact)

          EmailMarketerService::Netatlantic::SubscriptionService
            .new(list)
            .update_member_demographics(response, member["EmailAddress"], params: member['fields'])
        end

      end

      def add_members(data, list)
        members = data.map do |item|
          if item.is_a?(Hash)
            { 'EmailAddress' => item[:email], 'FullName' => item[:full_name] }
          else
            { 'EmailAddress' => item, 'FullName' => '' }
          end
        end
        HTTParty.post("#{API_PATH}/create_members.php", body: { members: members.to_json, account: list.account.account_name, list: list.name }.compact)
      end
    end
  end
end
