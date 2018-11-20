module Esp
  class BatchSendToAdopiaWorker
    include Sidekiq::Worker

    TARGET_BATCH_SIZE = 2000.freeze

    def perform
      return if available_leads.empty?
      lists.each_with_index do |list, index|
        result = send_data(chunked_leads[index], list.adopia_account.name, list.name)
        mark_as_sent(chunked_leads[index])
        logger.info("Sent #{leads_to_send.count} to '#{list_name}', successfully sent: #{result.processed_emails.count}")
      end
    end

    private

    def lists
      @lists ||= AdopiaList.joins(:adopia_account).includes(:adopia_account).where.not(adopia_accounts: { name: excluded_accounts }).to_a
    end

    def excluded_accounts
      %w(resource applyforjobsdirect)
    end

    def leads_to_send
      available_leads.limit(batch_size).to_a
    end

    def chunked_leads
      leads_to_send.in_groups_of(per_list)
    end

    def send_data(leads_to_send, account_name, list_name)
      data = leads_to_send.to_a.map do |lead|
        {
          contact_email: lead.email,
          contact_name: lead.full_name,
          OriginReferrer: lead.referrer
        }
      end
      service = EmailMarketerService::Adopia::BatchSendLeads.new(data, account_name, list_name)
      service.call
      service
    end

    def mark_as_sent(leads)
      sent_leads = PendingLead.where(id: leads.map(&:id))
      sent_leads.update_all(sent_to_adopia: true)
    end

    def available_leads
      old_dump_leads.order('id DESC').not_sent_to_adopia
    end

    def old_dump_leads
      PendingLead.with_valid_referrers
    end

    # Round a number of leads to send to fit lists count
    def batch_size
      (TARGET_BATCH_SIZE.to_f / lists.count).ceil * lists.count
    end

    def per_list
      batch_size / list.count
    end
  end
end
