module EmailMarketerService
  module Aweber
    class FindLeads
      EVENT_TYPES = %w(open click).freeze
      DEFAULT_DATE = Date.new(2018, 8, 30) # Date since when statistic collectiong began

      def initialize(since: nil)
        @auth_services = {}
        @accounts = {}
        @since = since ? since : last_lead_date
        @openers = []
      end

      def call
        Leads::Aweber.import(collect_leads)
      end

      private

      def users
        @users ||= User.added_to_aweber.includes(:aweber_list).includes(:leads)
      end

      def collect_leads
        leads = []
        users.each do |user|
          next if user.leads.to_a.any? { |lead| lead.status.in?(EVENT_TYPES) }

          begin
            subscriber = subscribers_for(user.aweber_list).search('email' => user.email)&.entries&.values&.first
            next if subscriber.nil? || !subscriber.custom_fields['Affiliate']
            subscriber.activity.each_page do |activity|
              values = activity&.entries&.values.to_a
              click = values.detect { |a| a.event_time.to_date >= @since && a.type = 'click' }
              open = values.detect { |a| a.event_time.to_date >= @since && a.type = 'open' }

              [click, open].compact.each do |event|
                leads << build_lead(user, subscriber, event)
              end
              break if click || open || (values.present? && values.last.event_time.to_date < @since)
            end
          rescue AWeber::ServiceUnavailableError, AWeber::UnknownRequestError => e
            puts "Aweber failed due to error: #{e.to_s}"
          end
        end
        leads
      end

      def build_lead(user, subscriber, event)
        {
          source_id: user.aweber_list.id,
          email: user.email,
          affiliate: subscriber.custom_fields['Affiliate'],
          status: event.type,
          user_id: user.id,
          date: event.event_time.to_date
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

      def last_lead_date
        Leads::Aweber.maximum(:created_at)&.to_date || DEFAULT_DATE
      end
    end
  end
end
