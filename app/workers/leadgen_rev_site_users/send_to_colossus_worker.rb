module LeadgenRevSiteUsers
  class SendToColossusWorker
    include Sidekiq::Worker

    DELAY = 24.hours.freeze

    def perform
      hour = Time.zone.now - DELAY
      leadrev_users = LeadgenRevSiteUser.is_verified.joins(:user).where(created_at: hour.beginning_of_hour..hour.end_of_hour)
      leadrev_users = leadrev_users.to_a.reject(&:sent_to_colossus?)
      # TODO make list either dynamic or hardcoded
      list = ColossusList.first
      leadrev_users.each do |lrsu|
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
end
