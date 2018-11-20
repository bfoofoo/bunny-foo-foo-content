class PendingLead < ApplicationRecord
  PROVIDERS = %w(netatlantic adopia).freeze

  PROVIDERS.each do |provider|
    scope "sent_to_#{provider}", -> { where("sent_to_#{provider}" => true) }
    scope "not_sent_to_#{provider}", -> { where("sent_to_#{provider}" => false) }
  end
end