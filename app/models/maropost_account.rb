class MaropostAccount < ApplicationRecord
  has_many :maropost_lists, dependent: :delete_all

  alias_attribute :lists, :maropost_lists

  after_create :fetch_lists

  def fetch_lists
    EmailMarketerService::Maropost::FetchLists.new(account: self).call
  end
end
