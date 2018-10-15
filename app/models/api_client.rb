class ApiClient < ApplicationRecord
  has_many :api_users
  has_many :api_client_mappings, as: :source, class_name: 'ApiClientMappings::Base'
  has_many :api_client_aweber_lists, as: :source, class_name: 'ApiClientMappings::Aweber'
  has_many :api_client_adopia_lists, as: :source, class_name: 'ApiClientMappings::Adopia'
  has_many :aweber_lists, through: :api_client_aweber_lists, source: :destination, source_type: 'AweberList'
  has_many :adopia_lists, through: :api_client_adopia_lists, source: :destination, source_type: 'AdopiaList'

  accepts_nested_attributes_for :api_client_aweber_lists, allow_destroy: true
  accepts_nested_attributes_for :api_client_adopia_lists, allow_destroy: true
end
