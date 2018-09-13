module Leads
  class Maropost < Lead
    belongs_to :user, optional: true
    belongs_to :source, class_name: 'MaropostList'
  end
end
