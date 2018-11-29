class MailgunList < ApplicationRecord
  include Esp::ListMethods

  belongs_to :mailgun_account
  has_many :mailgun_templates_schedules, dependent: :destroy
  has_many :mailgun_templates, through: :mailgun_templates_schedules

  validates :name, uniqueness: { scope: :mailgun_account_id }

  alias_attribute :account, :mailgun_account
end
