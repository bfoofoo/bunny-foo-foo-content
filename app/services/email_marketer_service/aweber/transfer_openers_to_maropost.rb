module EmailMarketerService
  module Aweber
    class TransferOpenersToMaropost
      attr_reader :result

      def initialize(aweber_list: nil, maropost_list: nil, since: nil)
        @aweber_list = aweber_list
        @maropost_list = maropost_list
        @since = since.is_a?(Date) ? since : Date.parse(since) rescue nil
        @result = { fetched: 0, created: 0, sent: 0 }
      end

      def call
        FetchOpeners.new(list: @aweber_list, since: @since).call do |subscribers|
          result[:fetched] += subscribers.count
          created = create_leads(build_lead_list(subscribers))
          if created
            result[:created] += created.ids.count
            result[:sent] += EmailMarketerService::Converters::AweberToMaropost.new(maropost_list: @maropost_list, ids: created.ids).call
          end
        end
      end

      private

      def build_lead_list(subscribers)
        subscribers.each_with_object([]) do |subscriber, memo|
          next if should_skip_subscriber?(subscriber)
          memo << {
            source_id: @aweber_list.id,
            destination_id: @maropost_list.id,
            email: subscriber.email,
            full_name: subscriber.name,
            details: {
              subscribed_at: subscriber.subscribed_at
            }
          }
        end
      end

      def create_leads(leads)
        return false if leads.empty?
        Leads::AweberToMaropost.import(leads)
      rescue => e
        puts "Error during import: #{e.to_s}"
        return false
      end

      def should_skip_subscriber?(subscriber)
        existing_lead_emails.include?(subscriber.email)
      end

      def existing_lead_emails
        @existing_lead_emails ||= Leads::AweberToMaropost.pluck(:email)
      end
    end
  end
end
