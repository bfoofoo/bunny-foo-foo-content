class ColossusAccount < EspAccount
  has_many :colossus_lists, dependent: :destroy, foreign_key: :account_id

  alias_attribute :lists, :colossus_lists
end


