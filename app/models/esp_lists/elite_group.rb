class EliteGroup < EspList
  belongs_to :elite_account, foreign_key: :account_id

  alias_attribute :account, :elite_account
  alias_attribute :list_id, :slug
  alias_attribute :group_id, :slug
end
