class ApiClientMapping < EmailMarketerMapping
  default_scope -> { where(source_type: 'ApiClient', destination_type: 'AweberList') }
end
