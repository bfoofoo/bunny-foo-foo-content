class AbstractSolutionsAccount < Account
  has_many :groups, foreign_key: :account_id, class_name: 'AbstractSolutionsGroup'

  validates :api_key, :username, :password, presence: true

  after_create :fetch_groups

  alias_attribute :name, :username

  def fetch_groups
    Sms::AbstractSolutions::FetchGroups.new(account: self)
  end
end