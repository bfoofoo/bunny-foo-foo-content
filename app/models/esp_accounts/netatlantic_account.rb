class NetatlanticAccount < EspAccount
  has_many :netatlantic_lists, dependent: :destroy, foreign_key: :account_id

  alias_attribute :account_name, :name
  alias_attribute :lists, :netatlantic_lists
end
