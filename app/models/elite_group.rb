class EliteGroup < ApplicationRecord
  belongs_to :elite_account

  alias_attribute :account, :elite_account

  validates :group_id, uniqueness: true

  def full_name
    return name if account.name.blank?
    "#{account.name} - #{name}"
  end
end
