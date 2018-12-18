class ConstantcontactAccount < EspAccount
  has_many :constantcontact_lists, dependent: :destroy, foreign_key: :account_id
  
  alias_attribute :lists, :constantcontact_lists
end



