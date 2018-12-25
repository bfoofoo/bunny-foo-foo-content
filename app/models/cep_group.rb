class CepGroup < ApplicationRecord
  belongs_to :account
  has_many :cep_rules, as: :cep_group, dependent: :destroy
end