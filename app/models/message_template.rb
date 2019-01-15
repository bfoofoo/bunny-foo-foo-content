class MessageTemplate < ApplicationRecord
  acts_as_paranoid

  has_many :message_schedules, dependent: :destroy

  def name
    "#{subject} (##{id})"
  end
end
