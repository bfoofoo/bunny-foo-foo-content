module Esp
  class BatchSendOldRefsToNetatlanticWorker
    include Sidekiq::Worker

    TARGET_BATCH_SIZE = 3000.freeze

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
        result = send_data(leads, list_name)
        mark_as_sent(leads, list_name)
        logger.info("Sent #{leads.count} to '#{list_name}', successfully sent: #{result.processed_emails.count}")
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

    def list_by_name(name)
      NetatlanticList.find_by(name: name)
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
      service = EmailMarketerService::Netatlantic::BatchSendLeads.new(data, list_name)
      service.call
      service
    end

    def mark_as_sent(leads, list_name)
      list = list_by_name(list_name)
      sent_leads = PendingLead.where(id: leads.map(&:id))
      exported_leads = sent_leads.map do |sl|
        {
          linkable_type: 'PendingLead',
          linkable_id: sl.id,
          list_type: 'NetatlanticList',
          list_id: list.id
        }
      end
      ExportedLead.import(exported_leads)
    end

    def available_leads
      @available_leads ||= PendingLead.with_valid_referrers.order('id DESC').not_sent_to_netatlantic
    end
  end
end
