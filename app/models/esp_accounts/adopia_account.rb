class AdopiaAccount < ApplicationRecord
  has_many :adopia_lists

  validates :api_key, uniqueness: true

  alias_attribute :lists, :adopia_lists

  after_create :fetch_lists

  def fetch_lists
    EmailMarketerService::Adopia::FetchLists.new(account: self).call
  end
end
