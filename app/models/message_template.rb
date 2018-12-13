class MessageTemplate < ApplicationRecord
  acts_as_paranoid

  has_many :message_schedules, dependent: :destroy
  has_many :message_recipients, dependent: :destroy

  def name
    "#{subject} (##{id})"
  end
end
