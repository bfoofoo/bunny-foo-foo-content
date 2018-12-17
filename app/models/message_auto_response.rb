class MessageAutoResponse < ApplicationRecord
  AUTORESPONDING_ESPS = %w(mailgun).freeze

  acts_as_paranoid

  belongs_to :message_template
  belongs_to :esp_list, polymorphic: true

  validates :message_template_id, :esp_list_id, presence: true
  validates :delay_in_minutes, numericality: { greater_than_or_equal_to: 0 }

  def instant?
    delay_in_minutes.zero?
  end

  def at
    delay_in_minutes.minutes.from_now
  end
end
