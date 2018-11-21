module Esp
  class BatchSendOldRefsToNetatlanticWorker
    include Sidekiq::Worker

    TARGET_BATCH_SIZE = 100.freeze

    def perform
      return if available_leads.empty?
      mappings.each do |referrer, list_name|
        leads = referrer_leads(referrer)
        result = send_data(leads, list_name)
        mark_as_sent(leads)
        logger.info("Sent #{leads.count} to '#{list_name}', successfully sent: #{leads.count}")
      end
    end

    private
    def referrer_leads referrer
      return leads_to_send.where(referrer: referrer)
    end

    def mappings
      {
        "resourcedepot.co" => "resourcedepot",
        "resourcedepot.info" => "resourcedepot",
        "www.resourcedepot.info" => "resourcedepot",
        "openposition.co" => "DD daily",
        "openposition.net" => "DD daily",
        "applyforjobs.us" => "typesofaid",
        "applyforlocaljobs.net" => "typesofaid",
      }
    end

    def excluded_accounts
      %w(resource applyforjobsdirect)
    end

    def leads_to_send
      @leads_to_send ||= available_leads.limit(TARGET_BATCH_SIZE)
    end

    def send_data(leads, list_name)    
      data = leads.to_a.map do |lead|
        {
          email: lead.email,
          full_name: lead.full_name,
        }
      end
      EmailMarketerService::Netatlantic::BatchSendLeads.new(data, list_name).call
    end

    def mark_as_sent(leads)
      sent_leads = PendingLead.where(id: leads.map(&:id))
      sent_leads.update_all(sent_to_netatlantic: true)
    end

    def available_leads
      PendingLead.with_valid_referrers.order('id DESC').not_sent_to_netatlantic
    end
  end
end
