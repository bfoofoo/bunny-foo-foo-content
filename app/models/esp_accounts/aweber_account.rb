class AweberAccount < ApplicationRecord
  has_many :aweber_lists, dependent: :destroy
end
