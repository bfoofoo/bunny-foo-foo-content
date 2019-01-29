class MailigenList < EspList
  belongs_to :mailigen_account, foreign_key: :account_id
  alias_attribute :account, :mailigen_account
  validates :list_id, uniqueness: true  
end
