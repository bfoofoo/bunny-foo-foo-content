module EmailMarketerService
  module Mailgun
    class SendMessage
      def initialize(list:, template:, schedule: nil)
        @list = list
        @template = template
        @schedule = schedule
      end

      def call
        if !@schedule || @schedule.is_batch?
          send_batch
        else
          import_recipients
          send_gradually
        end
      end

      private

      def import_recipients
        body = fetch_recipients("/lists/#{@list.address}/members/pages")
        emails = parse_emails(body)
        return if emails.blank?


        while true do
          body = client.get(body['next_link'])
          break if parse_emails(body).blank?
          emails += parse_emails(body)
        end

        data = emails.to_a.map do |email|
          {
            email: email,
            message_schedule_id: @schedule.id
          }
        end
        MessageRecipient.transaction do
          MessageRecipient.where(message_schedule_id: @schedule.id).delete_all
          MessageRecipient.import(data)
        end
      end

      def fetch_recipients(link)
        response = client.get(link)
        body = JSON.parse(response.body)
        return if body.try(:fetch, 'items').blank?
        body
      rescue JSON::ParserError
        nil
      end

      def parse_emails(body)
        return [] if body.try(:fetch, 'items').blank?
        body['items'].map { |r| r['address'] }
      end

      def send_gradually
        @delivery_time = Time.zone.now
        recipients = MessageRecipient.where(message_schedule_id: @schedule.id).to_a
        recipients.each do |r|
          params = {
            from: "#{@template.author} #{@template.author.parameterize.underscore}@#{domain}",
            to: r.email,
            subject: @template.subject,
            html: @template.body,
            'o:deliverytime' => @delivery_time.rfc2822
          }
          client.post("/#{domain}/messages", params)
          @delivery_time += interval(recipients.count).seconds
        end
      end

      def send_batch
        params = {
          from: "#{@template.author} #{@template.author.parameterize.underscore}@#{domain}",
          to: @list.address,
          subject: @template.subject,
          html: @template.body
        }
        client.post("/#{domain}/messages", params)
      end

      # calculate interval between each recipient in seconds
      def interval(recipients_count)
        @schedule.time_span / recipients_count.to_f * 60
      end

      def domain
        @list.address.split('@').second
      end

      def client
        return @client if defined?(@client)
        @client = ::Mailgun::Client.new(@list.account.api_key)
      end
    end
  end
end
