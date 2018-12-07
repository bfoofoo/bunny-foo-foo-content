class SuppressionList < ApplicationRecord
  FILE_NAME_DELIMITER = "---"
  
  mount_uploader :file, SuppressionListUploader

  scope :between_dates, -> (start_date, end_date) { 
    where("created_at >= ? AND created_at <= ?", start_date, end_date)
  }

  scope :for_list, -> (list) { where("file_name LIKE ?", "%#{list}#{FILE_NAME_DELIMITER}%") }

  before_save :handle_file_name

  def handle_file_name
    self.file_name = self.file.file.filename
  end

  def self.list_uniq_file_lists
    SuppressionList.all.pluck(:file_name).map {|file_name|
      file_name.split(FILE_NAME_DELIMITER)
    }.select {|names| names.count > 1 }.map {|name| name.first}
  end

end
