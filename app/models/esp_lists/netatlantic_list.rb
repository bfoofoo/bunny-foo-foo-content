class NetatlanticList < EspList
  belongs_to :netatlantic_account, foreign_key: :account_id

  alias_attribute :account, :netatlantic_account
end
