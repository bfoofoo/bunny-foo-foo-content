class ExportedLead < ApplicationRecord
  belongs_to :list, polymorphic: true
  belongs_to :linkable, polymorphic: true
  belongs_to :esp_rule
  has_many :message_auto_responses, through: :list

  validates :list, :linkable, presence: true

  after_create :autorespond

  def autorespond
    Messages::AutoResponseService.new(list).call(self)
  end
end
