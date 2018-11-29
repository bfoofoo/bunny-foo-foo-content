class MailgunTemplate < ApplicationRecord
  has_many :mailgun_templates_schedules, dependent: :destroy
  has_many :mailgun_lists, through: :mailgun_templates_schedules
end
