class LeadgenRevSiteUser
  class CloneUseCase
    attr_reader :email, :leadgen_rev_site

    def initialize(leadgen_rev_site_id, email)
      @email = email
      @leadgen_rev_site_id = leadgen_rev_site_id
    end

    def perform
      return if email.blank? || user.blank? || leadgen_rev_site.blank?
      clone_leadrev_user
    end

    private

    def leadgen_rev_site
      @leadgen_rev_site ||= LeadgenRevSite.find_by(id: @leadgen_rev_site_id)
    end

    def user
      @user ||= User.find_by(email: email)
    end

    def last_leadrev_user
      @last_leadrev_user ||= user.leadgen_rev_site_users.last
    end

    def clone_leadrev_user
      last_leadrev_user.dup.tap do |nlu|
        nlu.is_email_duplicate = is_email_duplicate?
        nlu.is_duplicate = is_ip_duplicate?
        nlu.leadgen_rev_site_id = @leadgen_rev_site_id
        nlu.save!
      end
    rescue => e
      puts e
      nil
    end

    def user_ip
      last_leadrev_user.ip
    end

    def is_email_duplicate?
      !leadgen_rev_site
         .leadgen_rev_site_users
         .joins(:user).where("users.email = ? AND users.created_at >= ?", user.email, LOOKBACK_PERIOD.ago)
         .blank?
    end

    def is_ip_duplicate?
      !leadgen_rev_site
         .leadgen_rev_site_users
         .where('leadgen_rev_site_users.ip = ? AND leadgen_rev_site_users.created_at >= ?', user_ip, LOOKBACK_PERIOD.ago)
         .blank?
    end
  end
end