class OngageAccount < ApplicationRecord
  has_many :ongage_lists

  validates :username, :password, :account_code, presence: true

  alias_attribute :lists, :ongage_lists

  after_create :fetch_lists

  def fetch_lists
    EmailMarketerService::Ongage::FetchLists.new(account: self).call
  end
end
