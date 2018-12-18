module EmailMarketerService
  module Mailgun
    class AutoRespond
      def initialize(list:, template:, lead:)
        @list = list
        @template = template
        @lead = lead
      end

      def call
        return unless email
        result = send_message
        update_lead(result.try(:fetch, 'id'))
      end

      private

      def send_message
        params = {
          from: "#{@template.author} #{@template.author.parameterize.underscore}@#{domain}",
          to: email,
          subject: @template.subject,
          html: @template.body
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

      def update_lead(message_id)
        return unless message_id
        if @lead.autoresponded_at?
          @lead.touch(:followed_up_at)
        else
          @lead.update(autoresponse_message_id: message_id, autoresponded_at: Time.zone.now)
        end
      end
    end
  end
end