module LeadgenRevSiteUsers
  class SendToColossusWorker
    include Sidekiq::Worker

    def perform
      # TODO make list either dynamic or hardcoded
      list = ColossusList.first
      pending_users.each do |lrsu|
        custom_fields = lrsu.custom_fields.symbolize_keys
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

    private

    def pending_users
      # TODO check certain `custom_fields` once we get more info
      @users ||=
        LeadgenRevSiteUser
          .left_joins(user: :exported_leads)
          .where.not(users: { id: nil, custom_fields: '' })
          .where("exported_leads.list_type <> 'ColossusList' OR exported_leads.id IS NULL")
    end
  end
end
