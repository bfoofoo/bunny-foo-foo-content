class SuppressionAweberList < SuppressionEmailMarketerList
  belongs_to :suppression_list, inverse_of: :suppression_aweber_lists
end
