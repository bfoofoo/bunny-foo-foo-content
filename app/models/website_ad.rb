class WebsiteAd < ApplicationRecord
  belongs_to :website, optional: true
  belongs_to :ad
end
