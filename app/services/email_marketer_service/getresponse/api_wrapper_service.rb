module EmailMarketerService
  module Getresponse
    class ApiWrapperService
      API_PATH="https://api.getresponse.com/v3"
      AUTH_HEADER_KEY="X-Auth-Token"
      AUTH_KEY_TYPE="api-key"

      def initialize(account:)
        @account = account
      end

      def call
        lists.map do |list|
          account.lists << AdopiaList.new(
            list_id: list.id,
            name: list.name
          )
        end
      end

      def lists
        HTTParty.get(uri("/campaigns"), query:{}, headers: auth_headers)
      end

      private

      def uri path
        return "#{API_PATH}#{path}"
      end

      def auth_headers
        return {
          "#{AUTH_HEADER_KEY}": "#{AUTH_KEY_TYPE} #{@account.api_key}"
        }
      end
    end
  end
end
