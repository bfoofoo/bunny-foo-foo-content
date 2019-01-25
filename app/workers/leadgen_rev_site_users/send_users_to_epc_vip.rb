module LeadgenRevSiteUsers
  class SendUsersToEpcVip
    include Sidekiq::Worker

    def perform
      hour = Time.zone.now.beginning_of_hour
      leadrev_users = LeadgenRevSiteUser.is_verified.joins(:user).where(created_at: hour - 8.days..hour - 7.days)
      leadrev_users = leadrev_users.to_a.reject(&:sent_to_epcvip?)
      leadrev_users.each do |lrsu|
        return unless lrsu.user
        leadgen_rev_site = LeadgenRevSite.find(lrsu.leadgen_rev_site_id)
        params = {
          affiliate: lrsu.affiliate,
          ipAddress: lrsu.ip,
          phone: lrsu.phone,
          zip: lrsu.zip,
          url: lrsu.url,
          ip: lrsu.ip,
          date: lrsu.created_at,
          signup_method: 'Webform',
          state: lrsu.state
        }.compact
        Sms::Epcvip::SubscriptionService.new(params: params).add(lrsu.user, leadgen_rev_site)
      end
    end
  end
end
