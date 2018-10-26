class NetatlanticAccount < ApplicationRecord
  has_many :netatlantic_lists, dependent: :destroy
end
