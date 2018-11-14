module Esp
  class BatchSendToAdopiaWorker
    include Sidekiq::Worker

    def call
      return if available_leads.empty?
      mappings.each do |key, value|
        leads_to_send = available_leads.where(destination_name: value['api_clients'].to_a + value['formsites'].to_a).limit(batch_sizes[Date.current.to_s])
        next if leads_to_send.empty?
        send_data(leads_to_send, key, value['account'])
        save_to_exported(leads_to_send, key, value['account'])
        mark_as_sent(leads_to_send)
        logger.info("Sent #{leads_to_send.count} to '#{value['account']}' - '#{key}'")
      end
    end

    private

    def mappings
      {
          "ResourceDepot"=>{
              "account"=>"resourcedepotupdates",
              "api_clients"=>["resourcedepot.info"],
              "formsites"=>["theresourcedepot.info", "the-resource-depot.com", "the-resource-guide.com"]
          },
          "FamilySupport"=>{
              "account"=>"findfamilysupport",
              "api_clients"=>["findfamilysupport.com", "hopeforamericans.net"],
              "formsites"=>["family-support-network.com", "find-family-resources.com"]
          },
          "ApplyForJobs"=>{
              "account"=>"localjobsearchdirect ",
              "api_clients"=>["findfamilysupport.com", "FileForUnemployment.net"],
              "formsites"=>["family-support-network.com", "yourjobresources.info", "file-for-unemployment.com"]
          },
          "Benefits Application"=>{
              "account"=>"findthelocaljobs",
              "api_clients"=>["findfamilysupport.com"],
              "formsites"=>["family-support-network.com", "applyforbenefits.info", "yourlocaljobresources.com"]
          },
          "Open Position"=>{
              "account"=>"findlocaljobsdirect",
              "api_clients"=>["openposition.net"],
              "formsites"=>["openposition.us", "open-positions.net"]
          },
          "Rent to Own Club"=>{
              "account"=>"localjobsearchdirect",
              "api_clients"=>["rent-to-own.club"],
              "formsites"=>["rent2ownclub.net", "rent-2ownclub.com", "from-rent-to-own.com"]
          },
          "Find Unclaimed Money"=>{
              "account"=>"resourceassistancenews",
              "api_clients"=>["rent-to-own.club", "findunclaimedmoney"],
              "formsites"=>["find-unclaimed-assets.net"]
          },
          "HousingBenefits"=>{
              "account"=>"findhousingbenefits",
              "api_clients"=>["findhousingbenefits.com"],
              "formsites"=>["findhousingbenefits.info", "find-housing-support.com"]
          },
          "Resource Finder"=>{
              "account"=>"jobsinmyareadirect",
              "api_clients"=>["findhousingbenefits.com", "resourcefinder.info", "applyforgrants.net"],
              "formsites"=>["findhousingbenefits.info", "resource-finder.com"]
          },
          "Openers new"=>{
              "account"=>"findthelocaljobs",
              "api_clients"=>["findhousingbenefits.com"]
          },
          "casapi"=>{
              "account"=>"resourcedepotupdates",
              "api_clients"=>["Cassidy-Api"]
          },
          "food"=>{
              "account"=>"findlocaljobsdirect",
              "api_clients"=>["findfoodresources"]
          },
          "flujobs"=>{
              "account"=>"findlocaljobsdirect",
              "api_clients"=>["fluent-jobs"]
          }
      }
    end

    def send_data(leads_to_send, list_name, account_name)
      data = leads_to_send.to_a.map do |lead|
        {
            contact_email: lead.email,
            contact_name: lead.full_name
        }
      end
      EmailMarketerService::Adopia::BatchSendLeads.new(data, account_name, list_name).call
    end

    def save_to_exported(leads_to_send, list_name, account_name)
      list = AdopiaList.joins(:adopia_account).find_by(adopia_lists: { name: list_name }, adopia_accounts: { name: account_name })
      formsite_user_ids = leads_to_send.to_a.select { |lead| lead.source_type == 'FormsiteUser' }.pluck(:id)
      formsite_users = FormsiteUser.joins(:user).where(formsite_users: { id: formsite_user_ids }).index_by(&:id)

      leads_to_send.select { |lead| lead.source_type == 'ApiUser' }.each do |lead|
        ExportedLead.find_or_create_by(list: list, linkable_type: 'ApiUser', linkable_id: lead.source_id)
      end

      formsite_users.each do |_, value|
        ExportedLead.find_or_create_by(list: list, linkable_type: 'User', linkable_id: value.user_id)
      end
    end

    def mark_as_sent(leads_to_send)
      api_user_ids = leads_to_send.to_a.select { |l| l.source_type == 'ApiUser' }.map(&:source_id)
      formsite_user_ids = leads_to_send.to_a.select { |l| l.source_type == 'FormsiteUser' }.map(&:source_id)
      PendingLead.where(source_type: 'ApiUser', source_id: api_user_ids).update_all(sent_at: Time.zone.now)
      PendingLead.where(source_type: 'FormsiteUser', source_id: formsite_user_ids).update_all(sent_at: Time.zone.now)
    end

    def available_leads
      PendingLead.order('created_at DESC').where(sent_at: nil)
    end

    def batch_sizes
      {
          '2018-11-14' => 2_000,
          '2018-11-15' => 4_000,
          '2018-11-16' => 4_000,
          '2018-11-17' => 4_000,
          '2018-11-18' => 4_000,
          '2018-11-19' => 8_000,
          '2018-11-20' => 8_000,
          '2018-11-21' => 8_000,
          '2018-11-22' => 8_000
      }
    end
  end
end