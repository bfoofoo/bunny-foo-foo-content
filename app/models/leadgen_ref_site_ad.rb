class LeadgenRefSiteAd < ApplicationRecord
  belongs_to :leadgen_ref_site, optional: true
  belongs_to :ad
end
