class MessageEvent < ApplicationRecord
  EVENTS = %w(welcome open click followup remind).freeze

  belongs_to :exported_lead, dependent: :destroy
  belongs_to :message_auto_response, dependent: :nullify
end
