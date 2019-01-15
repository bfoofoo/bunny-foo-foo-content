module LeadgenRevSiteUsers
  class SendToColossusWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'colossus'

    def perform(leadgen_rev_site_user_id)
      lrsu = LeadgenRevSiteUser.find(leadgen_rev_site_user_id)
      # TODO make list either dynamic or hardcoded
      list = ColossusList.first
      custom_fields = lrsu.custom_fields.try(:symbolize_keys) || {}
      params = {
        ip: lrsu.ip,
        phone: lrsu.phone,
        state: lrsu.state,
        date: lrsu.created_at,
        url: lrsu.url,
        **custom_fields
      }
      EmailMarketerService::Colossus::SubscriptionService.new(list, params: params).add(lrsu.user)
    end
  end
end
