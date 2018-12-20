class PrelanderSiteUserAnswer < ApplicationRecord
    belongs_to :prelander_site_user, optional: true
    belongs_to :prelander_site, optional: true
    belongs_to :question, optional: true
    
end
