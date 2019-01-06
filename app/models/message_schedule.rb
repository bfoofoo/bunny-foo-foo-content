class MessageSchedule < ApplicationRecord
  acts_as_paranoid

  belongs_to :message_template
  belongs_to :esp_list, polymorphic: true

  validates :message_template_id, :esp_list_id, :time, presence: true
  validates :time_span, numericality: { greater_than_or_equal_to: 0 }
  validate :check_time, on: :create

  after_commit :schedule_sending, on: [:create]
  after_update :schedule_sending, if: :time_changed?
  before_destroy :cancel

  def is_batch?
    time_span.zero?
  end

  private

  def schedule_sending
    response = Messages::SchedulingService.new(self).schedule_sending
    update_column(:scheduled_job_id, response) if response
  end

  def cancel
    Messages::SchedulingService.new(self).cancel
  end

  def check_time
    errors.add(:time, 'Should be in future') if time && !time.future?
  end
end
