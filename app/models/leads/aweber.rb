module Leads
  class Aweber < Lead
    belongs_to :user, optional: true
    belongs_to :source, class_name: 'AweberList'

    scope :by_account_id, -> (account_id) do
      joins('INNER JOIN email_marketer_campaigns ON email_marketer_campaigns.campaign_id = leads.campaign_id')
        .where(email_marketer_campaigns: { origin: 'Aweber', account_id: account_id })
    end
  end
end
