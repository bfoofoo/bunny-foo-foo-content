module Leads
  class Aweber < Lead
    belongs_to :user, optional: true
  end
end
