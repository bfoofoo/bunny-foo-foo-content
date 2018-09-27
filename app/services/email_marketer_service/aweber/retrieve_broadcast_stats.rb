module EmailMarketerService
  module Aweber
    class RetrieveBroadcastStats
      attr_reader :result

      EVENT_TYPES = %w(open click sent_message).freeze
      DEFAULT_DATE = Date.new(2018, 8, 1) # Date since when statistic collection began

      def initialize(since: nil)
        @auth_services = {}
        @subscribers = {}
        @accounts = {}
        @since = since || DEFAULT_DATE
        @result = { campaigns: 0, leads: 0 }
      end

      def call
        collect_campaigns
        collect_leads
        result
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
          collection = endpoint.broadcasts('sent')
          next if collection.nil?

          catch :no_more_broadcasts do
            collection.each_page do |page|
              broadcasts = page&.entries&.values.to_a
              broadcasts.each do |broadcast|
                throw :no_more_broadcasts if broadcast.sent_at.to_date < DEFAULT_DATE
                find_or_create_campaign(broadcast, list)
                sleep 0.5
              end
              sleep 0.5
            end
          end
          sleep 0.5
        end
      end

      def find_or_create_campaign(broadcast, list)
        campaign = broadcast.detailed
        return unless campaign
        account = account_for(list)
        EmailMarketerCampaign.find_or_initialize_by(origin: 'Aweber', campaign_id: broadcast.id) do |c|
          c.subject = campaign.subject
          c.source_url = campaign.self_link
          c.sent_at = campaign.sent_at
          c.list_ids = campaign.list_ids
          c.account_id = account.account_id
        end.update(stats: {
          'sent' => campaign.stats&.[]('num_emailed'),
          'opens' => campaign.stats&.[]('unique_opens'),
          'clicks' => campaign.stats&.[]('unique_clicks')
        })
        @result[:campaigns] += 1
      end

      def collect_leads
        users.each do |user|
          begin
            subscriber = auth_service_for(user.aweber_list).aweber.account.find_subscribers('email' => user.email)&.entries&.values&.first
            next if subscriber.nil?
            catch :no_more_campaigns do
              subscriber.activity.each_page do |activity|
                values = activity&.entries&.values.to_a
                events = values.select { |a| a.type.in?(EVENT_TYPES) && a.event_time && a.event_time.to_date >= @since }

                events.each do |event|
                  campaign = event.campaign
                  throw :no_more_campaigns if (campaign&.sent_at && campaign&.sent_at&.to_date < @since)
                  Leads::Aweber.find_or_create_by(lead_params(user, subscriber, event)) do |lead|
                    lead.event_at = campaign&.sent_at
                    lead.email = user.email
                  end
                  @result[:leads] += 1
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
    end
  end
end
