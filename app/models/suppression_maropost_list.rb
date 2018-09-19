class SuppressionMaropostList < SuppressionEmailMarketerList
  belongs_to :suppression_list, inverse_of: :suppression_maropost_lists
end
