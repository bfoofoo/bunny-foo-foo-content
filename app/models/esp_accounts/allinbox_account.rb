class AllInboxAccount < EspAccount
  has_many :allinbox_lists, dependent: :destroy, foreign_key: :account_id

  alias_attribute :lists, :allinbox_lists
end


