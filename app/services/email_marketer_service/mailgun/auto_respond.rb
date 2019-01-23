module EmailMarketerService
  module Mailgun
    class AutoRespond
      def initialize(list:, auto_response:, lead:)
        @list = list
        @auto_response = auto_response
        @lead = lead
      end

      def call
        return unless email
        result = send_message
        create_message_event(result.try(:fetch, 'id'))
      end

      private

      def template
        @auto_response.message_template
      end

      def send_message
        params = {
          from: "#{template.author} #{template.author.parameterize.underscore}@#{domain}",
          to: email,
          subject: template.subject,
          html: template.body,
          'o:tracking' => true
        }
        response = client.post("/#{domain}/messages", params)
        JSON.parse(response.body)
      rescue JSON::ParserError
        false
      end

      def client
        return @client if defined?(@client)
        @client = ::Mailgun::Client.new(@list.account.api_key)
      end

      def email
        @lead.linkable.try(:email)
      end

      def domain
        @list.address.split('@').second
      end

      def event_type
        return 'welcome' unless @auto_response.followup
        case @auto_response.event
        when 'nothing' then 'remind'
        when nil then 'followup'
        else @auto_response.event
        end
      end

      def create_message_event(message_id)
        @lead.message_events.create(
          message_id: message_id.tr('<>', ''),
          event_type: event_type,
          message_auto_response_id: @auto_response.id
        )
      end
    end
  end
end
