class LeadgenRevSiteAd < ApplicationRecord
  belongs_to :leadgen_rev_site, optional: true
  belongs_to :ad
end
