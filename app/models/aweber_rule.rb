class AweberRule < ApplicationRecord
  belongs_to :list_to, class_name: 'AweberList', foreign_key: :list_to_id
  belongs_to :list_from, class_name: 'AweberList', foreign_key: :list_from_id
  
  validates :time, presence: true
end
