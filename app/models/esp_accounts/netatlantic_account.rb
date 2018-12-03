class NetatlanticAccount < EspAccount
  has_many :netatlantic_lists, dependent: :destroy

  alias_attribute :account_name, :name
  alias_attribute :lists, :netatlantic_lists
end
