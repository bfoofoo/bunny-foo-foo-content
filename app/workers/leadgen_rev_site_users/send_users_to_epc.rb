module LeadgenRevSiteUsers
  class SendUsersToEpcVip
    include Sidekiq::Worker

    def perform
      leadrev_users = LeadgenRevSiteUser.joins(:user).where(created_at: (Time.zone.now.beginning_of_hour - ( 8 * 86400))..Time.zone.now - ( 7 * 86400 ))
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

    private


  end
end
