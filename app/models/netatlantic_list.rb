class NetatlanticList < ApplicationRecord
  belongs_to :netatlantic_account

  def full_name
    return "#{netatlantic_account.account_name} - #{name}"
  end

  def id_with_type
    "#{model_name.name}_#{self.id}"
  end
end
