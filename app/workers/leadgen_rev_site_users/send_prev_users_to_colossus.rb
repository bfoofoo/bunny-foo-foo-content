module LeadgenRevSiteUsers
  class SendPrevUsersToColossus
    include Sidekiq::Worker

    def perform
      LeadgenRevSiteUserAnswer.joins(answer: :question).where(questions: { for_prelander: true })

      leadrev_users = LeadgenRevSiteUser.joins(:user).where(id: leadrev_user_ids)
      leadrev_users.each do |lrsu|
        return unless lrsu.user
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

    private

    def leadrev_user_ids
      LeadgenRevSiteUserAnswer
        .select(:leadgen_rev_site_user_id)
        .joins(answer: :question)
        .left_joins(leadgen_rev_site_user: { user: :exported_leads })
        .where(questions: { for_prelander: true })
        .where('exported_leads.id IS NULL OR exported_leads.list_type <> ?', 'ColossusList')
        .group(:leadgen_rev_site_user_id)
        .having('MAX(leadgen_rev_site_user_answers.created_at) < ?', 10.minutes.ago)
    end
  end
end
