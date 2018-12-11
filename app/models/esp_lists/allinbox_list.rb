class AllinboxList < EspList
  belongs_to :allinbox_account, foreign_key: :account_id
  alias_attribute :account, :allinbox_account
end
