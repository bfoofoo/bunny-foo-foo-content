module EmailMarketerService
  module Netatlantic
    class SubscriptionService < EmailMarketerService::Netatlantic::BaseService
      attr_reader :list, :params, :account

      def initialize(list, params: nil, esp_rule: nil)
        @list = list
        @params = params
        @account = @list.netatlantic_account
        @esp_rule = esp_rule
      end

      def add(user)
        user_name = user.try(:full_name).blank? ? user.try(:name) : user.full_name
        response = HTTParty.post("#{API_PATH}/create_member.php", body: {email: user.email, full_name: user_name, account: account.account_name, list: list.name})

        update_member_demographics(response, user.email, params: params)
        update_member_status(response, user.email, list.member_status)
        handle_user_record(user)
      end

      def update_member_demographics(user_response, email, params:{})
        if user_response["success"] == true
          body_params = { 
            account: list.account.account_name,
            list: list.name,
            simple_member_struct: {
              "MemberID" => user_response["memberid"],
              "EmailAddress" => email,
              "ListName" => list.name
            },
            fields: {
              "field_1_" => params[:ip],
              "field_2_" => params[:signup_method],
              "field_3_" => params[:state],
              "field_4_" => params[:url],
              "field_5_" => params[:date]
            }
          }
          HTTParty.post("#{API_PATH}/update_member_demographics.php", body: body_params.compact)
        end
      end

      def update_member_status(user_response, email, status)
        return if !user_response['success'] || status == 'normal'
        payload = {
          simple_member_struct: {
            "MemberID" => user_response["memberid"],
            "EmailAddress" => email,
            "ListName" => list.name
          },
          status: status
        }
        HTTParty.post("#{API_PATH}/update_member_status.php", body: payload.compact)
      end

      private

      def handle_user_record(user)
        ExportedLead.find_or_create_by(list_id: list.id, list_type: list.type, linkable: user).update(esp_rule: @esp_rule) if user.is_a?(ActiveRecord::Base)
      end
    end
  end
end
