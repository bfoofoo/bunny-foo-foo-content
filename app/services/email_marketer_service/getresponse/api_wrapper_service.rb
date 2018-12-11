module EmailMarketerService
  module Getresponse
    class ApiWrapperService
      API_PATH = "https://api.getresponse.com/v3"
      AUTH_HEADER_KEY = "X-Auth-Token"
      AUTH_KEY_TYPE = "api-key"
      CUSTOM_FIELDS = {
        "url" => "YJlIN",
        "method" => "bW0bx",
        "ipaddress" => "bkGXO",
        "join_date" => "bkG7n",
        "state" => "YJlqn",
        "affiliate" => "bkXc4"
      }

      CUSTOM_FIELD_MAPPING = {
        "url" => :url,
        "method" => :signup_method,
        "ipaddress" => :ip,
        "join_date" => :date,
        "state" => :state,
        "affiliate" => :affiliate
      }

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

      def create_contact(params)
        HTTParty.post(uri("/contacts"), body: params, headers: auth_headers)
      end

      def get_fields(params = {})
        HTTParty.get(uri("/custom-fields"), body: params, headers: auth_headers)
      end

      private

      def uri path
        return "#{API_PATH}#{path}"
      end

      def auth_headers
        return {
          "#{AUTH_HEADER_KEY}": "#{AUTH_KEY_TYPE} #{@account.api_key}",
          "Content-Type" => "application/json"
        }
      end
    end
  end
end
