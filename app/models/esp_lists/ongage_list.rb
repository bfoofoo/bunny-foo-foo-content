class OngageList < EspList
  belongs_to :ongage_account, foreign_key: :account_id

  alias_attribute :account, :ongage_account

  validates :list_id, uniqueness: true
end
