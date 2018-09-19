class SuppressionEmailMarketerList < ApplicationRecord
  belongs_to :removable, polymorphic: true
end
