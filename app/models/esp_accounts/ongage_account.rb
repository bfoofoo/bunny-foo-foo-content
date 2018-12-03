class OngageAccount < EspAccount
  has_many :ongage_lists, dependent: :destroy, foreign_key: :account_id

  validates :username, :password, :account_code, presence: true

  alias_attribute :lists, :ongage_lists

  after_create :fetch_lists

  def fetch_lists
    EmailMarketerService::Ongage::FetchLists.new(account: self).call
  end

  def display_name
    account_code
  end
end
