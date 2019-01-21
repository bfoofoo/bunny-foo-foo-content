class MessageTemplate < ApplicationRecord
  acts_as_paranoid

  has_many :message_schedules, dependent: :destroy

  def name
    label.blank? ? "#{subject} (##{id})" : label
  end
end
