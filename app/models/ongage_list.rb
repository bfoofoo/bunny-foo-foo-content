class OngageList < ApplicationRecord
  belongs_to :ongage_account, dependent: :destroy

  alias_attribute :account, :ongage_account

  validates :list_id, uniqueness: true

  def full_name
    return name if account.account_code.blank?
    "#{account.account_code} - #{name}"
  end
end
