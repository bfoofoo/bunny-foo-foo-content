class EliteAccount < EspAccount
  has_many :elite_groups, dependent: :destroy, foreign_key: :account_id

  validates :api_key, presence: true, uniqueness: true

  alias_attribute :groups, :elite_groups
  alias_attribute :lists, :elite_groups
  alias_attribute :sender, :username

  after_create :fetch_groups

  def fetch_groups
    EmailMarketerService::Elite::FetchGroups.new(account: self).call
  end

  def display_name
    username
  end
end
