module EmailMarketerService
  module Aweber
    class RetrieveBroadcastStats
      EVENT_TYPES = %w(open click sent_message).freeze
      DEFAULT_DATE = Date.new(2018, 8, 1) # Date since when statistic collection began

      def initialize(since: nil)
        @auth_services = {}
        @subscribers = {}
        @accounts = {}
        @since = since || last_campaign_date
        @openers = []
      end

      def call
        collect_campaigns
        collect_leads
      end

      private

      def users
        @users ||=
          User
            .added_to_aweber
            .joins(:formsite_users)
            .includes(:aweber_list, :leads, :formsite_users)
      end

      def collect_campaigns
        AweberList.all.includes(:aweber_account).each do |list|
          endpoint = auth_service_for(list).aweber.account.lists[list.list_id]
          collection = search_campaigns(endpoint)
          next if collection.nil?
          collection.each_page do |page|
            campaigns = page.collection.reject { |c| !c['sent_at'] || c['sent_at'].to_date < DEFAULT_DATE }
            campaigns.each { |campaign| find_or_create_campaign(campaign, list) }
            break if !page.collection.empty? && page.collection.last['sent_at'].to_date < DEFAULT_DATE
          end
        end
      end

      def search_campaigns(endpoint)
        retries = 0
        begin
          endpoint.search_broadcast_campaigns
        rescue AWeber::UnknownRequestError => e
          puts e.to_s
          retries += 1
          retry if retries < 2
        end
      end

      def find_or_create_campaign(campaign, list)
        entry = EmailMarketerCampaign.find_or_initialize_by(origin: 'Aweber', campaign_id: campaign['id']) do |c|
          c.subject = campaign['subject']
          c.source_url = campaign['self_link']
          c.stats = {
            'sent' => campaign['total_sent'],
            'opens' => campaign['total_opens'],
            'clicks' => campaign['total_clicks']
          }
          c.sent_at = campaign['sent_at']
        end

        entry.update(list_ids: entry.list_ids.push(list.id)) unless entry.list_ids.include?(list.id)
      end

      def collect_leads
        users.each do |user|
          begin
            subscriber = auth_service_for(user.aweber_list).aweber.account.find_subscribers('email' => user.email)&.entries&.values&.first
            next if subscriber.nil?
            subscriber.activity.each_page do |activity|
              values = activity&.entries&.values.to_a
              events = values.select { |a| a.event_time.to_date >= @since && a.type.in?(EVENT_TYPES) }

              events.each do |event|
                campaign = event.campaign
                break 2 if campaign&.sent_at && campaign&.sent_at&.to_date < @since
                Leads::Aweber.find_or_create_by(lead_params(user, subscriber, event)) do |lead|
                  lead.event_at = campaign&.sent_at
                  lead.email = user.email
                end
              end
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

      def account_for(list)
        @accounts[list.aweber_account_id] ||= list.aweber_account
      end

      def auth_service_for(list)
        id = list.list_id
        return @auth_services[id] if @auth_services[id].present?
        @auth_services[id] = EmailMarketerService::Aweber::AuthService.new(
          access_token: account_for(list).access_token,
          secret_token: account_for(list).secret_token,
          )
      end

      def last_campaign_date
        EmailMarketerCampaign.where(origin: 'Aweber').last&.sent_at&.to_date|| DEFAULT_DATE
      end

      def broadcasts_for(list)
        account_for(list).broadcasts&.entries&.values.to_a
      end
    end
  end
end
