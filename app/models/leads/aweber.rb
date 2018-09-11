module Leads
  class Aweber < Lead
    belongs_to :user, optional: true
    belongs_to :source, class_name: 'AweberList'

    def event_date_string
      event_at.to_date.to_s(:db)
    end
  end
end
