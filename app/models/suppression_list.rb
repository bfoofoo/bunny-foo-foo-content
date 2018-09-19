class SuppressionList < ApplicationRecord
  has_many :suppression_aweber_lists, -> { where(removable_type: 'AweberList') }
  has_many :suppression_maropost_lists, -> { where(removable_type: 'MaropostList') }
  has_many :aweber_lists, through: :suppression_aweber_lists, source: :removable, source_type: 'AweberList'
  has_many :maropost_lists, through: :suppression_maropost_lists, source: :removable, source_type: 'MaropostList'

  accepts_nested_attributes_for :suppression_aweber_lists, allow_destroy: true
  accepts_nested_attributes_for :suppression_maropost_lists, allow_destroy: true

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
