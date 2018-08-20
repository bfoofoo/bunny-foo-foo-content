class MaropostAccount < ApplicationRecord
  has_many :maropost_lists

  alias_attribute :lists, :maropost_lists
end