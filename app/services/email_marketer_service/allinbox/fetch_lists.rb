module EmailMarketerService
  module Allinbox
    class FetchLists
      attr_reader :account

      def initialize(account:)
        @account = account
      end

      def call
          account.lists.find_or_create_by(
            list_id: 993,
          ).update(name: 'trd')
          account.lists.find_or_create_by(
            list_id: 994,
          ).update(name: 'dbc')          
        end
      end

      
    
    end
  end

