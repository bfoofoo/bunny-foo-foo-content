class SparkpostList < EspList
  belongs_to :sparkpost_account, foreign_key: :account_id
  alias_attribute :account, :sparkpost_account

  alias_attribute :list_id, :slug
end
