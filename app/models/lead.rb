class Lead < ApplicationRecord
  scope :not_converted, -> { where(converted_at: nil) }
end
