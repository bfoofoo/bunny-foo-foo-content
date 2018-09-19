class SuppressionEmailMarketerList < ApplicationRecord
  belongs_to :suppression_list
  belongs_to :removable, polymorphic: true
end
