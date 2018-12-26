class CepGroup < ApplicationRecord
  PROVIDERS = %w(AbstractSolutions Waypoint).freeze

  belongs_to :account
  has_many :cep_rules, dependent: :destroy
  has_many :sms_subscribers, through: :cep_rules
end