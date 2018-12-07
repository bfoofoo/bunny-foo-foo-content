class EspList < ApplicationRecord
  has_one :exported_lead, as: :list

  delegate :sending_limit, to: :account

  def id_with_type
    "#{model_name.name}_#{self.id}"
  end

  def full_name
    return name if account.display_name.blank?
    "#{account.display_name} - #{name}"
  end
end
