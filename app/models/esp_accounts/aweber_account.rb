class AweberAccount < EspAccount
  has_many :aweber_lists, dependent: :destroy, foreign_key: :account_id

  alias_attribute :lists, :aweber_lists
end
