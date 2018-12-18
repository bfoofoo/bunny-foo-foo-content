class ConstantcontactList < EspList
  belongs_to :constantcontact_account, foreign_key: :account_id
  alias_attribute :account, :constantcontact_account
end
