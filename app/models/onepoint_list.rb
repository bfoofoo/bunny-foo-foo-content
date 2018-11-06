class OnepointList < ApplicationRecord
  belongs_to :onepoint_account

  def full_name
    return "#{onepoint_account.username} - #{name}"
  end

  def id_with_type
    "#{model_name.name}_#{self.id}"
  end
end
