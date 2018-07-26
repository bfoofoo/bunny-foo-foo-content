class FormsiteAd < ApplicationRecord
  belongs_to :formsite, optional: true
  belongs_to :ad
end
