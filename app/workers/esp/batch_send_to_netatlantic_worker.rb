module Esp
  class BatchSendToNetatlanticWorker
    include Sidekiq::Worker

    BATCH_SIZE = 2000.freeze

    def perform
      return if available_leads.empty?
      selected_leads = available_leads.where(destination_name: all_api_clients + all_formsites).limit(BATCH_SIZE).to_a
      mappings.each do |list_name, value|
        leads_to_send = selected_leads
                          .select { |l| l.destination_name.in?(value['api_clients'].to_a + value['formsites'].to_a) }
                          .select { |l| is_impressionwise_test_success(l.email) }
        next if leads_to_send.empty?
        send_data(leads_to_send, list_name)
        save_to_exported(leads_to_send, list_name)
        mark_as_sent(leads_to_send)
        logger.info("Sent #{leads_to_send.count} to '#{list_name}'")
      end
    end

    private

    def mappings
      {
        "resourcedepot" => {
          "api_clients" => ["resourcedepot.info"],
          "formsites" => ["theresourcedepot.info", "the-resource-depot.com"]
        },
        "rent2ownclub" => {
          "api_clients" => ["rent-to-own.club"],
          "formsites" => ["rent2ownclub.net", "rent-2ownclub.com", "from-rent-to-own.com"]
        },
        "typesofaid" => {
          "api_clients" => ["applyforgrants.net", "findfoodresources"],
          "formsites" => ["applyforbenefits.info", "findfoodresources.com"]
        },
        "findunclaimedassets" => {
          "api_clients" => ["findunclaimedmoney"],
          "formsites" => ["find-unclaimed-assets.net"]
        },
        "theresourcedepot" => {
          "formsites" => ["find-resources.net"]
        },
        "dd-daily" => {
          "formsites" => ["file-for-unemployment.com"]
        }
      }
    end

    def all_api_clients
      mappings.map { |_, v| v['api_clients'] }.flatten.compact
    end

    def all_formsites
      mappings.map { |_, v| v['formsites'] }.flatten.compact
    end

    def formsite_service
      @formsite_service ||= FormsiteService.new
    end

    def is_impressionwise_test_success(email)
      formsite_service.is_impressionwise_test_success({email: email})
    end

    def send_data(leads_to_send, list_name)
      data = leads_to_send.to_a.map do |lead|
        {
          email: lead.email,
          full_name: lead.full_name
        }
      end
      EmailMarketerService::Netatlantic::BatchSendLeads.new(data, list_name).call
    end

    def save_to_exported(leads_to_send, list_name)
      list = NetatlanticList.find_by(name: list_name)
      leads_to_send.each do |lead|
        linkable_type = lead.source_type == 'ApiUser' ? 'ApiUser' : 'User'
        linkable_id = lead.source_type == 'ApiUser' ? lead.id : lead.user_id
        ExportedLead.find_or_create_by(list_id: list.id, list_type: list.type, linkable_type: linkable_type, linkable_id: linkable_id)
      end
    end

    def mark_as_sent(leads_to_send)
      api_user_ids = leads_to_send.to_a.select { |l| l.source_type == 'ApiUser' }.map(&:source_id)
      formsite_user_ids = leads_to_send.to_a.select { |l| l.source_type == 'FormsiteUser' }.map(&:source_id)
      netatlantic_leads.where(source_type: 'ApiUser', source_id: api_user_ids).update_all(sent_at: Time.zone.now)
      netatlantic_leads.where(source_type: 'FormsiteUser', source_id: formsite_user_ids).update_all(sent_at: Time.zone.now)
    end

    def available_leads
      netatlantic_leads.order('created_at DESC').where(sent_at: nil)
    end

    def netatlantic_leads
      PendingLead.where(destination_type: 'NetatlanticList')
    end

    # Not used
    # Listed purely to explain how leads are generated
    # TODO maybe move somewhere
    def generate_pending_leads
      api_users = ApiUser.joins(:api_client).where(api_clients: { name: all_api_clients }).includes(:api_client).verified.order('api_users.created_at DESC')
      formsite_users = FormsiteUser.joins(:formsite, :user).where(formsites: { name: all_formsites }).includes(:formsite, :user).is_verified.order('formsite_users.created_at DESC')
      a_leads = api_users.map { |a| { source_id: a.id, source_type: 'ApiUser', destination_type: 'NetatlanticList', destination_name: a.api_client.name, created_at: a.created_at, email: a.email, full_name: a.full_name } }
      f_leads = formsite_users.map { |f| { source_id: f.id, source_type: 'FormsiteUser', destination_type: 'NetatlanticList', destination_name: f.formsite.name, created_at: f.created_at, email: f.user.email, full_name: f.user.full_name, user_id: f.user.id } }
      PendingLead.import(a_leads)
      PendingLead.import(f_leads)
    end
  end
end
