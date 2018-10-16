class EliteAccount < ApplicationRecord
  has_many :elite_groups

  validates :api_key, uniqueness: true

  alias_attribute :lists, :elite_groups

  after_create :fetch_lists

  def fetch_lists
    # TODO implement
  end
end
