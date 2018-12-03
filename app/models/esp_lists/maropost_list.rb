class MaropostList < EspList
  belongs_to :maropost_account, foreign_key: :account_id
  alias_attribute :account, :maropost_account

  validates :list_id, :account_id, :name, presence: true
  validates :list_id, uniqueness: { scope: :account_id }
end
