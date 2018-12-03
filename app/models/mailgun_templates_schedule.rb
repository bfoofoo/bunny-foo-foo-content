class MailgunTemplatesSchedule < ApplicationRecord
  belongs_to :mailgun_template
  belongs_to :mailgun_list

  validates :sending_time, presence: true
end
