class EmailMarketerListUser < ApplicationRecord
  belongs_to :list, polymorphic: true
  belongs_to :user
end
