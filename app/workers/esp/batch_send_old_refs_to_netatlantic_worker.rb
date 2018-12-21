module Esp
  class BatchSendOldRefsToNetatlanticWorker
    include Sidekiq::Worker

    TARGET_BATCH_SIZE = 7500.freeze

    def perform
      return if available_leads.empty?
      leads_to_send.each_slice(TARGET_BATCH_SIZE / destination_lists.count).with_index do |slice, index|
        list_name = destination_lists[index % destination_lists.count]
        leads = slice.select do |l|
          result = valid_email?(l.email) && is_impressionwise_test_success(l.email)
          l.destroy unless result
          result
        end
        next if leads.empty?
        send_data(leads, list_name)
        mark_as_sent(leads)
        logger.info("Sent #{leads.count} to '#{list_name}', successfully sent: #{leads.count}")
      end
    end

    private

    def formsite_service
      @formsite_service ||= FormsiteService.new
    end

    def valid_email?(email)
      email =~ URI::MailTo::EMAIL_REGEXP
    end

    def is_impressionwise_test_success(email)
      formsite_service.is_impressionwise_test_success({email: email})
    end

    def destination_lists
      %w(resourcedepot dd-daily typesofaid)
    end

    def leads_to_send
      @leads_to_send ||= available_leads.limit(TARGET_BATCH_SIZE).to_a
    end

    def send_data(leads, list_name)
      data = leads.to_a.map do |lead|
        {
          email: lead.email,
          full_name: lead.full_name,
          fields: {
            ip: lead.ip_address,
            url: lead.referrer,
            date: lead.joined_at
          }
        }
      end
      EmailMarketerService::Netatlantic::BatchSendLeads.new(data, list_name).call
    end

    def mark_as_sent(leads)
      sent_leads = PendingLead.where(id: leads.map(&:id))
      sent_leads.update_all(sent_to_netatlantic: true, sent_at: Time.zone.now)
    end

    def available_leads
      PendingLead.with_valid_referrers.order('id DESC').not_sent_to_netatlantic
    end
  end
end
