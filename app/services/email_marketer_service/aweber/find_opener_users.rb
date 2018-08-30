module EmailMarketerService
  module Aweber
    class FindOpenerUsers
      def initialize(since: nil)
        @auth_services = {}
        @accounts = {}
        @since = since ? since : Date.current
        @openers = []
      end

      def call
        AweberOpener.import(collect_openers)
      end

      private

      def users
        User.added_to_aweber.includes(:aweber_list)
      end

      def collect_openers
        openers = []
        users.each do |user|
          begin
            subscriber = subscribers_for(user.aweber_list).search('email' => user.email)&.entries&.values&.first
            next unless subscriber || subscriber.custom_fields['Affiliate']
            subscriber.activity.each_page do |activity|
              values = activity&.entries&.values.to_a
              finds = values.select { |a| a.type == 'open' && a.event_time.to_date >= @since }
              openers << build_opener(user, subscriber) if finds.present?
              break if finds.present? || (values.present? && values.last.event_time.to_date < @since)
            end
          rescue AWeber::ServiceUnavailableError, AWeber::UnknownRequestError => e
            puts "Aweber failed due to error: #{e.to_s}"
          end
        end
        openers
      end

      def build_opener(user, subscriber)
        {
          source_list_id: user.aweber_list.id,
          source_list_type: 'AweberList',
          email: user.email,
          affiliate: subscriber.custom_fields['Affiliate']
        }
      end

      def subscribers_for(list)
        auth_service_for(list).aweber.account.lists[list.list_id].subscribers
      end

      def account_for(list)
        @accounts[list.list_id] ||= list.aweber_account
      end

      def auth_service_for(list)
        id = list.list_id
        return @auth_services[id] if !@auth_services[id].blank?
        @auth_services[id] = EmailMarketerService::Aweber::AuthService.new(
          access_token: account_for(list).access_token,
          secret_token: account_for(list).secret_token,
          )
      end
    end
  end
end
