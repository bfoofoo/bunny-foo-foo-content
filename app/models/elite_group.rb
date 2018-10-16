class EliteGroup < ApplicationRecord
  belongs_to :elite_account

  alias_attribute :account, :elite_account

  validates :group_id, uniqueness: true

  def full_name
    return name if account.sender.blank?
    "#{account.sender} - #{name}"
  end
end
