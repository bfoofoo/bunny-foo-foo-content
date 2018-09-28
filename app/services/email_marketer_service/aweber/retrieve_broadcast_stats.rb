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

      def all_affiliates
        FormsiteUser.distinct(:affiliate).pluck(:affiliate).compact
      end

      def collect_campaigns
        AweberList.all.includes(:aweber_account).each do |list|
          endpoint = auth_service_for(list.aweber_account).aweber.account.lists[list.list_id]
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
        all_affiliates.each do |affiliate|
          aweber_accounts.each do |account|
            endpoint = auth_service_for(account).aweber.account
            begin
              collection = endpoint.find_subscribers('custom_fields' => { 'Affiliate' => affiliate })
              collection.each_page do |page|
                process_subscribers(page&.entries&.values.to_a)
              end
            rescue AWeber::NotFoundError
              nil
            end
          end
        end
      end

      def process_subscribers(subscribers)
        subscribers.each do |subscriber|
          catch :no_more_campaigns do
            subscriber.activity.each_page do |activity|
              values = activity&.entries&.values.to_a
              events = values.select { |a| a.type.in?(EVENT_TYPES) && a.event_time && a.event_time.to_date >= @since }

              events.each do |event|
                campaign = event.campaign
                throw :no_more_campaigns if (campaign&.sent_at && campaign&.sent_at&.to_date < @since)
                Leads::Aweber.find_or_create_by(lead_params(subscriber, event)) do |lead|
                  lead.event_at = campaign&.sent_at
                end
                @result[:leads] += 1
              end
            end
          end
        end
      end

      def lead_params(subscriber, event)
        affiliate = subscriber.custom_fields['Affiliate']
        {
          source_id: subscriber.list_id,
          affiliate: affiliate,
          status: event.type,
          email: subscriber.email,
          campaign_id: event.campaign&.id
        }.compact
      end

      def aweber_accounts
        @aweber_accounts ||= AweberAccount.all
      end

      def account_for(list)
        @accounts[list.aweber_account_id] ||= list.aweber_account
      end

      def auth_service_for(aweber_account)
        id = aweber_account.account_id
        return @auth_services[id] if @auth_services[id].present?
        @auth_services[id] = EmailMarketerService::Aweber::AuthService.new(
          access_token: aweber_account.access_token,
          secret_token: aweber_account.secret_token,
          )
      end
    end
  end
end
