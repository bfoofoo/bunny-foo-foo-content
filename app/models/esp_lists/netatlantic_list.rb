class NetatlanticList < EspList
  MEMBER_STATUSES = %w(normal needs-hello).freeze

  belongs_to :netatlantic_account, foreign_key: :account_id

  alias_attribute :account, :netatlantic_account
end
