class AdopiaList < ApplicationRecord
  belongs_to :adopia_account

  validates :list_id, uniqueness: true

  def full_name
    return name if adopia_account.name.blank?
    "#{adopia_account.name} - #{name}"
  end
end