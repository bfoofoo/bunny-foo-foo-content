module Esp
  class BatchSendOldRefsToNetatlanticWorker
    include Sidekiq::Worker

    TARGET_BATCH_SIZE = 15000.freeze

    def perform
      return if available_leads.empty?
      mappings.each do |referrer, list_name|
        leads = referrer_leads(referrer).select { |l| is_impressionwise_test_success(l.email) }
        send_data(leads, list_name)
        mark_as_sent(leads)
        logger.info("Sent #{leads.count} to '#{list_name}', successfully sent: #{leads.count}")
      end
    end

    private

    def referrer_leads(referrer)
      leads_to_send.select { |l| l.referrer == referrer }
    end

    def formsite_service
      @formsite_service ||= FormsiteService.new
    end

    def is_impressionwise_test_success(email)
      formsite_service.is_impressionwise_test_success({email: email})
    end

    def mappings
      {
        'homeresourcedepot.com' => 'resourcedepot',
        'myresourcedepot.com' => 'resourcedepot',
        'resourcedepotapp.com' => 'resourcedepot',
        'resourcedepotart.com' => 'resourcedepot',
        'resourcedepot.info' => 'resourcedepot',
        'resourcedepotstudio.com' => 'resourcedepot',
        'resourcedepotweb.com' => 'resourcedepot',
        'resourcedepot.co' => 'resourcedepot',
        'www.resourcedepot.info' => 'resourcedepot',
        "openposition.co" => "DD daily",
        "openposition.net" => "DD daily",
        "open-positions.net" => "DD daily",
        "applyforjobs.us" => "typesofaid",
        "applyforlocaljobs.net" => "typesofaid",
        "apply-for-jobs.com" => "typesofaid",
        "governmentgrants.info" => "typesofaid",
        "www.apply-for-jobs.com" => "typesofaid",
        "www.applyforjobs.us" => "typesofaid",
        "applyforbenefits.net" => "typesofaid",
        "applyforgrants.net" => "typesofaid",
        "grantresources.org" => "typesofaid",
        "housinggrantinfo.com" => "typesofaid",
        "findunclaimedmoney.net" => "typesofaid"
      }
    end

    def excluded_accounts
      %w(resource applyforjobsdirect)
    end

    def leads_to_send
      @leads_to_send ||= available_leads.limit(TARGET_BATCH_SIZE).to_a
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
      PendingLead.where(referrer: mappings.keys).order('id DESC').not_sent_to_netatlantic
    end
  end
end
