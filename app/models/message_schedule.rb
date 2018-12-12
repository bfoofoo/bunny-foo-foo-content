class MessageSchedule < ApplicationRecord
  acts_as_paranoid

  belongs_to :message_template
  belongs_to :esp_list, polymorphic: true

  validates :message_template_id, :esp_list_id, :time, presence: true
  validates :time_span, numericality: { greater_than_or_equal_to: 0 }

  def is_batch?
    time_span.zero?
  end
end
