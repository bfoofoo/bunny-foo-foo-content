class MaropostAccount < EspAccount
  has_many :maropost_lists, dependent: :destroy, foreign_key: :account_id

  alias_attribute :lists, :maropost_lists

  after_create :fetch_lists

  def fetch_lists
    EmailMarketerService::Maropost::FetchLists.new(account: self).call
  end
end
