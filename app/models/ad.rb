class Ad < ApplicationRecord
  has_many :websites
  has_many :formsites

  scope :advertisements, -> () { where.not(position: "tracker")}
  scope :trackers, -> () { where(position: "tracker")}
end
