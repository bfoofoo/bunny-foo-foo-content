class CepRule < ApplicationRecord
  belongs_to :cep_group
  belongs_to :leadgen_rev_site
end