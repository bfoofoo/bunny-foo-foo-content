module EmailMarketerService
  module Colossus
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
          account.lists.find_or_create_by(
            list_id: 1676,
          ).update(name: 'list1')
        end
      end  
    end
  end

