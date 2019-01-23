class MessageEvent < ApplicationRecord
  EVENTS = %w(welcome open click followup remind).freeze
  READ_EVENTS = %w(open click).freeze
  FOLLOWUP_EVENTS = EVENTS - %w(welcome).freeze

  belongs_to :exported_lead, dependent: :destroy
  belongs_to :message_auto_response
  has_one :message_schedule, through: :message_auto_response

  def not_read
    !self.class.where(message_id: [message_id], event_type: READ_EVENTS).exists?
  end
end
