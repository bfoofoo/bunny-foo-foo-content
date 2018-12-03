class OnepointAccount < EspAccount
  has_many :onepoint_lists, dependent: :destroy, foreign_key: :account_id

  alias_attribute :lists, :onepoint_lists

  validates :api_key, :username, presence: true, uniqueness: true

  after_create :fetch_lists

  def fetch_lists
    EmailMarketerService::Onepoint::FetchLists.new(account: self).call
  end

  def display_name
    username
  end
end
