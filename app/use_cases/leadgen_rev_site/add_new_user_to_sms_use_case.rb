class LeadgenRevSite
  class AddNewUserToSmsUseCase

    attr_reader :leadgen_rev_site, :user, :leadgen_rev_site_user, :params

    def initialize(leadgen_rev_site, user, leadgen_rev_site_user)
      @user = user
      @leadgen_rev_site = leadgen_rev_site
      @leadgen_rev_site_user = leadgen_rev_site_user
      @params = {
        affiliate: leadgen_rev_site_user.affiliate,
        ipAddress: leadgen_rev_site_user.ip,
        phone: leadgen_rev_site_user.phone,
        zip: leadgen_rev_site_user.zip,
        url: leadgen_rev_site_user.url,
        ip: leadgen_rev_site_user.ip,
        date: leadgen_rev_site_user.created_at,
        signup_method: 'Webform',
        state: leadgen_rev_site_user.state
      }.compact
    end

    def perform
      return false if !leadgen_rev_site_user.is_verified || user.blank?
      Sms::Waypoint::SubscriptionService.new(params: params).add(user)
    end
  end
end
