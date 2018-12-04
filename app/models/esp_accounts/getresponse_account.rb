class GetresponseAccount < EspAccount
  has_many :getresponse_lists, dependent: :destroy, foreign_key: :account_id

  validates :api_key, uniqueness: true

  alias_attribute :lists, :getresponse_lists

  after_create :fetch_lists

  def fetch_lists
    EmailMarketerService::Getresponse::FetchLists.new(account: self).call
  end
end
