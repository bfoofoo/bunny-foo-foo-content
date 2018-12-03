class SparkpostAccount < EspAccount
  has_many :sparkpost_lists, dependent: :destroy

  validates :api_key, presence: true
  validates :api_key, :account_id, uniqueness: true

  alias_attribute :lists, :sparkpost_lists

  def display_name
    username
  end
end
