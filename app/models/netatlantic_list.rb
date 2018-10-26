class NetatlanticList < ApplicationRecord
  belongs_to :netatlantic_account

  def full_name
    return "#{netatlantic_account.sender} - #{name}"
  end

  def id_with_type
    "#{model_name.name}_#{self.id}"
  end
end
