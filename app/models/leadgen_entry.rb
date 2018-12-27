class LeadgenEntry < ApplicationRecord
  ENTRIES = %w(/join1 /join2 /join3 /join4 /join5 /explore-plus2a /explore-plus2b /explore-plus2c /explore-plus2d /explore-plus2e).freeze

  acts_as_paranoid
  mount_uploader :background, BackgroundUploader

  belongs_to :leadgen_rev_site

  validates :entry, presence: true
  validates :entry, uniqueness: { scope: :leadgen_rev_site_id }
end