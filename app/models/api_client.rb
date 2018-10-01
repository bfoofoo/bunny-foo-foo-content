class ApiClient < ApplicationRecord
  has_many :api_users
  has_many :api_client_mappings, as: :source
  has_many :aweber_lists, through: :api_client_mappings, source: :destination, source_type: 'AweberList'
end
