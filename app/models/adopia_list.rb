class AdopiaList < ApplicationRecord
  belongs_to :adopia_account

  validates :list_id, uniqueness: true
end
