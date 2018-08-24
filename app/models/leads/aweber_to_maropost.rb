module Leads
  class AweberToMaropost < Lead
    validates :email, presence: true
    validates :email, uniqueness: true

    belongs_to :source, class_name: 'AweberList'
    belongs_to :destination, class_name: 'MaropostList'
  end
end
