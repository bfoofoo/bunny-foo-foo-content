class MailigenAccount < EspAccount
  has_many :mailigen_lists, dependent: :destroy, foreign_key: :account_id
  
  alias_attribute :lists, :mailigen_lists
end
