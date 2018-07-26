class Ad < ApplicationRecord
  has_many :websites
  has_many :formsites

  scope :trackers, -> () { where(position: "tracker")}
end
