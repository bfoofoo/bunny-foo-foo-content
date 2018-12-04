class AdopiaList < EspList
  belongs_to :adopia_account, foreign_key: :account_id
  alias_attribute :account, :adopia_account

  validates :list_id, uniqueness: true
end
