class EspAccount < ApplicationRecord
  def provider
    type.underscore.split('_').first
  end

  def display_name
    name
  end

  def sending_limit
    EspSendingLimit.find_by(provider: provider.capitalize)
  end
end
