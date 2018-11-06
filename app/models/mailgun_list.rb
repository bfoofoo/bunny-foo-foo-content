class MailgunList < ApplicationRecord
  belongs_to :mailgun_account

  validates :name, uniqueness: { scope: :mailgun_account_id }

  alias_attribute :account, :mailgun_account

  def full_name
    return name if account.name.blank?
    "#{account.name} - #{name}"
  end

  def id_with_type
    "#{model_name.name}_#{self.id}"
  end
end
