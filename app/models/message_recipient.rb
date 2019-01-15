class MessageRecipient < ApplicationRecord
  belongs_to :message_schedule, dependent: :destroy
end