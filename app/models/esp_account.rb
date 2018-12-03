class EspAccount < ApplicationRecord
  def provider
    type.underscore.split('_').last
  end

  def display_name
    name
  end
end
