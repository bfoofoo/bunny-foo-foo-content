module Leads
  class Aweber < Lead
    belongs_to :user, optional: true
    belongs_to :source, class_name: 'AweberList'
  end
end
