class PrelanderSiteUser < ApplicationRecord
    TEST_USER_EMAIL="bf@test.com"
    
    acts_as_paranoid

    belongs_to :prelander_site
    belongs_to :user, optional: true
    
end
