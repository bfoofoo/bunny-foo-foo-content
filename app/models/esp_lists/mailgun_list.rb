class MailgunList < EspList
  belongs_to :mailgun_account, foreign_key: :account_id

  has_many :message_schedules, as: :esp_list

  alias_attribute :account, :mailgun_account

  validates :name, uniqueness: { scope: :account_id }
end
