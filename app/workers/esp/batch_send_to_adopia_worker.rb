module Esp
  class BatchSendToAdopiaWorker
    include Sidekiq::Worker

    TARGET_BATCH_SIZE = 15000.freeze

    def perform
      return if available_leads.empty?
      lists.each_with_index do |list, index|
        return unless chunked_leads[index]
        leads = chunked_leads[index].compact
        leads.select! do |l|
          result = is_impressionwise_test_success(l.email)
          l.destroy unless result
          result
        end
        next if leads.empty?
        result = send_data(leads, list.adopia_account.name, list.name)
        mark_as_sent(leads)
        logger.info("Sent #{leads.count} to '#{list.name}', successfully sent: #{result.processed_emails.count}")
      end
    end

    private

    def lists
      @lists ||= AdopiaList.joins(:adopia_account).includes(:adopia_account).where.not(adopia_accounts: { name: excluded_accounts }).to_a
    end

    def excluded_accounts
      %w(resource applyforjobsdirect)
    end

    def formsite_service
      @formsite_service ||= FormsiteService.new
    end

    def is_impressionwise_test_success(email)
      formsite_service.is_impressionwise_test_success({email: email})
    end


    def leads_to_send
      @leads_to_send ||= available_leads.limit(batch_size).to_a
    end

    def chunked_leads
      @chunked_leads ||= leads_to_send.in_groups_of(per_list)
    end

    def send_data(leads, account_name, list_name)
      data = leads.to_a.map do |lead|
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
      PendingLead.select(:id, :email, :full_name, :referrer, :deleted_at).with_valid_referrers.order('id DESC').not_sent_to_adopia
    end

    # Round a number of leads to send to fit lists count
    def batch_size
      @batch_size ||= (TARGET_BATCH_SIZE.to_f / lists.count).ceil * lists.count
    end

    def per_list
      @per_list ||= batch_size / lists.count
    end
  end
end
