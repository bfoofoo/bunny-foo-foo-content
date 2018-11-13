class SparkpostAccount < ApplicationRecord
  has_many :sparkpost_lists

  validates :api_key, presence: true
  validates :api_key, :account_id, uniqueness: true

  alias_attribute :lists, :sparkpost_lists
end