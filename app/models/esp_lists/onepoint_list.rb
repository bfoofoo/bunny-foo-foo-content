class OnepointList < EspList
  belongs_to :onepoint_account, foreign_key: :account_id

  alias_attribute :account, :onepoint_account
end
