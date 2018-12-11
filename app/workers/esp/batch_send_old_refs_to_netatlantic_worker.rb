module Esp
  class BatchSendOldRefsToNetatlanticWorker
    include Sidekiq::Worker

    TARGET_BATCH_SIZE = 15000.freeze
    DEFAULT_LIST = 'dd-daily'.freeze

    def perform
      return if available_leads.empty?
      grouped_leads.each do |referrer, leads_by_referrer|
        list_name = mappings[referrer] || DEFAULT_LIST
        leads = leads_by_referrer.select do |l|
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

    def grouped_leads
      @grouped_leads = leads_to_send.group_by(&:referrer)
    end

    def formsite_service
      @formsite_service ||= FormsiteService.new
    end

    def valid_email?(email)
      email =~ Devise.email_regexp
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
        "openposition.co" => "dd-daily",
        "openposition.net" => "dd-daily",
        "open-positions.net" => "dd-daily",
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
      sent_leads.update_all(sent_to_netatlantic: true, sent_at: Time.zone.now)
    end

    def available_leads
      PendingLead.select(:id, :email, :full_name, :referrer, :deleted_at).with_valid_referrers.order('id DESC').not_sent_to_netatlantic
    end
  end
end
