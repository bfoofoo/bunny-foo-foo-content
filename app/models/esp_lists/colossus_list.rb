class ColossusList < EspList
  belongs_to :colossus_account, foreign_key: :account_id
  alias_attribute :account, :colossus_account
end
