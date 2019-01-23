class ExportedLead < ApplicationRecord
  belongs_to :list, polymorphic: true
  belongs_to :linkable, polymorphic: true
  belongs_to :esp_rule
  has_many :message_auto_responses, through: :list
  has_many :message_events

  validates :list, :linkable, presence: true

  after_create :autorespond

  scope :welcomed, -> { joins(:message_events).where(event_type: 'welcome') }
  scope :by_message, ->(message_id) { joins(:message_events).where(message_events: { message_id: message_id }) }
  scope :message_not_read, ->(message_id) do
    where(MessageEvent.joins(:exported_lead).where(message_id: [message_id], event_type: MessageEvent::READ_EVENTS).exists.not)
  end

  scope :joins_linkable, -> do
    joins("LEFT JOIN users ON users.id = exported_leads.linkable_id AND exported_leads.linkable_type = 'User'")
      .joins("LEFT JOIN api_users ON api_users.id = exported_leads.linkable_id AND exported_leads.linkable_type = 'ApiUser'")
  end

  def autorespond(message_id = nil, event: nil)
    return if message_id && message_events.where(message_id: message_id, event_type: event).exists?
    Messages::AutoResponseService.new(list).call(self, event)
  end
end
