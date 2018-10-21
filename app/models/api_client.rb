class ApiClient < ApplicationRecord
  has_many :api_users
  has_many :esp_rules, as: :source, class_name: 'EspRules::ApiClient'
=begin
  has_many :api_client_mappings, as: :source, class_name: 'ApiClientMappings::Base'
  has_many :api_client_aweber_lists, as: :source, class_name: 'ApiClientMappings::Aweber'
  has_many :api_client_adopia_lists, as: :source, class_name: 'ApiClientMappings::Adopia'
  has_many :api_client_elite_groups, as: :source, class_name: 'ApiClientMappings::Elite'
  has_many :api_client_ongage_lists, as: :source, class_name: 'ApiClientMappings::Ongage'
  has_many :aweber_lists, through: :api_client_aweber_lists, source: :destination, source_type: 'AweberList'
  has_many :adopia_lists, through: :api_client_adopia_lists, source: :destination, source_type: 'AdopiaList'
  has_many :elite_groups, through: :api_client_elite_groups, source: :destination, source_type: 'EliteGroup'
  has_many :ongage_lists, through: :api_client_elite_groups, source: :destination, source_type: 'OngageList'

  accepts_nested_attributes_for :api_client_aweber_lists, allow_destroy: true
  accepts_nested_attributes_for :api_client_adopia_lists, allow_destroy: true
  accepts_nested_attributes_for :api_client_elite_groups, allow_destroy: true
  accepts_nested_attributes_for :api_client_ongage_lists, allow_destroy: true
=end

  accepts_nested_attributes_for :esp_rules, allow_destroy: true
end
