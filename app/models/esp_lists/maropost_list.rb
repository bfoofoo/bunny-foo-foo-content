class MaropostList < ApplicationRecord
  belongs_to :maropost_account

  alias_attribute :account, :maropost_account

  validates :list_id, :maropost_account_id, :name, presence: true
  validates :list_id, uniqueness: { scope: :maropost_account_id }

  def full_name
    return name if maropost_account.name.blank?
    "#{maropost_account.name} - #{name}"
  end

  def id_with_type
    "#{model_name.name}_#{self.id}"
  end
end
