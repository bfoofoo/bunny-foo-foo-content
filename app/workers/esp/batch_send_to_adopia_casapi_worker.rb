module Esp
  class BatchSendToAdopiaCasapiWorker
    include Sidekiq::Worker

    BATCH_SIZE = 2000.freeze

    def perform
      
      return if available_leads.empty?
      selected_leads = available_leads.where(destination_name: "resourcedepotupdates").limit(BATCH_SIZE).to_a
      mappings.each do |list_name, value|
        leads_to_send = selected_leads.select { |l|  is_impressionwise_test_success(l.email)}
        next if leads_to_send.empty?
        send_data(leads_to_send, value["account_name"], list_name)
        mark_as_sent(leads_to_send)
        logger.info("Sent #{leads_to_send.count} to '#{list_name}'")
      end
    end

    private

    def formsite_service
      @formsite_service ||= FormsiteService.new
    end

    def is_impressionwise_test_success(email)
      formsite_service.is_impressionwise_test_success({email: email})
    end

    def mappings
      {
        "casapi" => {
          "account_name" =>  "resourcedepotupdates",
          "destination_type" => "AdopiaList"
        }
      }
    end

    def send_data(leads_to_send, account_name, list_name)
      data = leads_to_send.to_a.map do |lead|
        lead.email
      end
      EmailMarketerService::Adopia::BatchSendLeads.new(data, account_name, list_name).call
    end

    def mark_as_sent(leads_to_send)
      leads_to_send = PendingLead.where(id: leads_to_send.pluck(:id))
      leads_to_send.update_all(sent_at: Time.zone.now)
    end

    def available_leads
      adopia_leads.order('created_at DESC').where(sent_at: nil)
    end

    def adopia_leads
      PendingLead.where(destination_type: 'AdopiaList')
    end
  end
end