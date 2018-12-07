class MailgunList < EspList
  belongs_to :mailgun_account, foreign_key: :account_id

  has_many :mailgun_templates_schedules, dependent: :destroy
  has_many :mailgun_templates, through: :mailgun_templates_schedules

  alias_attribute :account, :mailgun_account

  validates :name, uniqueness: { scope: :account_id }
end
