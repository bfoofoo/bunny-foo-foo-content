module Leads
  class AweberToMaropost < Lead
    validates :email, presence: true
    validates :email, uniqueness: true
  end
end
