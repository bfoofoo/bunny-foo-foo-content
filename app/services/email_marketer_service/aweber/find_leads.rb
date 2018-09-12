module EmailMarketerService
  module Aweber
    class FindLeads
      EVENT_TYPES = %w(open click).freeze
      DEFAULT_DATE = Date.new(2018, 8, 1) # Date since when statistic collection began

      def initialize(since: nil)
        @auth_services = {}
        @subscribers = {}
        @accounts = {}
        @since = since ? since : last_lead_date
        @openers = []
      end

      def call
        collect_leads
      end

      private

      def users
        @users ||=
          User
            .added_to_aweber
            .joins(:formsite_users)
            .includes(:aweber_list, :leads, :formsite_users)
            .where.not(formsite_users: { affiliate: nil })
      end

      def collect_leads
        users.each do |user|
          begin
            subscriber = subscribers_for(user.aweber_list).search('email' => user.email)&.entries&.values&.first
            affiliate = subscriber&.custom_fields&.[]('Affiliate') || user.formsite_users.first.affiliate
            next if subscriber.nil? || !affiliate
            subscriber.activity.each_page do |activity|
              values = activity&.entries&.values.to_a
              events = values.select { |a| a.event_time.to_date >= @since && a.type.in?(EVENT_TYPES) }

              events.each do |event|
                campaign = event.campaign
                Leads::Aweber.find_or_create_by(lead_params(user, subscriber, event)) do |lead|
                  lead.event_at = campaign&.sent_at
                  lead.email = user.email
                end
              end
              break if (values.present? && values.last.event_time.to_date < @since)
            end
          rescue AWeber::ServiceUnavailableError, AWeber::UnknownRequestError, AWeber::NotFoundError => e
            puts "Aweber failed due to error: #{e.to_s}"
          rescue AWeber::RateLimitError
            sleep 60
            retry
          end
        end
      end

      def lead_params(user, subscriber, event)
        affiliate = subscriber.custom_fields['Affiliate'] || user.formsite_users.first.affiliate
        {
          source_id: user.aweber_list.id,
          affiliate: affiliate,
          status: event.type,
          user_id: user.id,
          campaign_id: event.campaign&.id
        }.compact
      end

      def subscribers_for(list)
        @subscribers[list.list_id] ||= auth_service_for(list).aweber.account.lists[list.list_id].subscribers
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
