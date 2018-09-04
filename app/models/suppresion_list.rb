class SuppresionList < ApplicationRecord
  mount_uploader :file, SuppresionListUploader

  scope :between_dates, -> (start_date, end_date) { 
    where("created_at >= ? AND created_at <= ?", start_date, end_date)
  }
end
