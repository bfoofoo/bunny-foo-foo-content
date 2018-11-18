module Esp
  class BatchSendToAdopiaCasapiWorker
    include Sidekiq::Worker

    BATCH_SIZE = 2000.freeze

    def perform
      return if available_leads.empty?
      selected_leads = available_leads.where(destination_name: "resourcedepotupdates").limit(BATCH_SIZE).to_a
      mappings.each do |list_name, value|
        leads_to_send = selected_leads.select { |l|  is_impressionwise_test_success(l.email)}
        leads_to_send = selected_leads
        next if leads_to_send.empty?
        send_data(leads_to_send, list_name)
        # save_to_exported(leads_to_send, list_name)
        # mark_as_sent(leads_to_send)
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

    def send_data(leads_to_send, list_name)
      data = leads_to_send.to_a.map do |lead|
        lead.email
      end
      EmailMarketerService::Adopia::BatchSendLeads.new(data, list_name).call
    end

    def mark_as_sent(leads_to_send)
      api_user_ids = leads_to_send.to_a.select { |l| l.source_type == 'ApiUser' }.map(&:source_id)
      formsite_user_ids = leads_to_send.to_a.select { |l| l.source_type == 'FormsiteUser' }.map(&:source_id)
      netatlantic_leads.where(source_type: 'ApiUser', source_id: api_user_ids).update_all(sent_at: Time.zone.now)
      netatlantic_leads.where(source_type: 'FormsiteUser', source_id: formsite_user_ids).update_all(sent_at: Time.zone.now)
    end

    def available_leads
      adopia_leads.order('created_at DESC').where(sent_at: nil)
    end

    def adopia_leads
      PendingLead.where(destination_type: 'AdopiaList')
    end
  end
end