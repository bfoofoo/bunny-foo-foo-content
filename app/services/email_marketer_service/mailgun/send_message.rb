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
        start_time = Time.zone.now
        end_time = start_time + @schedule.time_span.minutes
        recipients = MessageRecipient.where(message_schedule_id: @schedule.id).order('RANDOM()').to_a
        recipients.each do |r|
          delivery_time = Time.zone.at((end_time.to_f - start_time.to_f)*rand + start_time.to_f)

          params = {
            from: "#{@template.author} #{@template.author.parameterize.underscore}@#{domain}",
            to: r.email,
            subject: @template.subject,
            html: @template.body,
            'o:deliverytime' => delivery_time.rfc2822
          }
          client.post("/#{domain}/messages", params)
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
