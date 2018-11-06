class OnepointAccount < ApplicationRecord
  has_many :onepoint_lists

  alias_attribute :lists, :onepoint_lists

  after_create :fetch_lists

  def fetch_lists
    EmailMarketerService::Onepoint::FetchLists.new(account: self).call
  end

  validates :api_key, :username, presence: true, uniqueness: true
end
