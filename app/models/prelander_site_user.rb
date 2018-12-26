class PrelanderSiteUser < ApplicationRecord
    acts_as_paranoid

    belongs_to :prelander_site
    belongs_to :user, optional: true
    
end
