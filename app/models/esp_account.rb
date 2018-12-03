class EspAccount < ApplicationRecord
  validates :daily_limit, numericality: { greater_than_or_equal_to: 0 }

  def provider
    type.underscore.split('_').last
  end

  def display_name
    name
  end
end
