class AweberList < EspList
  belongs_to :aweber_account, foreign_key: :account_id
  alias_attribute :account, :aweber_account
end
