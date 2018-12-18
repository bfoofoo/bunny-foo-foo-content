class ExportedLead < ApplicationRecord
  belongs_to :list, polymorphic: true
  belongs_to :linkable, polymorphic: true
  belongs_to :esp_rule
  has_many :message_auto_responses, through: :list

  validates :list, :linkable, presence: true

  after_create :autorespond

  scope :autoresponded, -> { where.not(autoresponded_at: nil) }
  scope :clickers, -> { where.not(clicked_at: nil) }
  scope :openers, -> { where.not(opened_at: nil) }
  scope :inactive_within, ->(minutes) { where(clicked_at: nil, opened_at: nil, followed_up_at: nil).where('autoresponded_at <= ?', minutes.minutes.ago) }
  scope :joins_linkable, -> do
    joins("LEFT JOIN users ON users.id = exported_leads.linkable_id AND exported_leads.linkable_type = 'User'")
      .joins("LEFT JOIN api_users ON api_users.id = exported_leads.linkable_id AND exported_leads.linkable_type = 'ApiUser'")
  end

  def autorespond(followup: false, event: nil)
    Messages::AutoResponseService.new(list).call(self, followup, event)
  end
end
