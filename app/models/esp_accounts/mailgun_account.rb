class MailgunAccount < EspAccount
  has_many :mailgun_lists, dependent: :destroy, foreign_key: :account_id

  validates :api_key, presence: true, uniqueness: true

  alias_attribute :lists, :mailgun_lists

  after_create :fetch_lists

  def fetch_lists
    EmailMarketerService::Mailgun::FetchLists.new(account: self).call
  end
end
