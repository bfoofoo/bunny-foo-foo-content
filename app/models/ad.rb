class Ad < ApplicationRecord
  ADVERTISEMENT_POSITIONS = %w(adSidebar adTop adMiddle adBottom adAppendedToBody adpushup).freeze
  WIDGET_POSITIONS = %w(widgetSidebar widgetTop widgetBottom).freeze
  TRACKER_POSITIONS = %w(tracker).freeze

  has_many :websites
  has_many :formsites

  scope :advertisements, -> { where(position: ADVERTISEMENT_POSITIONS) }
  scope :trackers, -> { where(position: TRACKER_POSITIONS) }
  scope :widgets, -> { where(position: WIDGET_POSITIONS) }
end
