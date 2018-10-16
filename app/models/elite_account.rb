class EliteAccount < ApplicationRecord
  has_many :elite_groups, dependent: :destroy

  validates :api_key, uniqueness: true

  alias_attribute :groups, :elite_groups
  alias_attribute :lists, :elite_groups

  after_create :fetch_groups

  def fetch_groups
    EmailMarketerService::Elite::FetchGroups.new(account: self).call
  end
end
