class ApiClientMapping < EmailMarketerMapping
  default_scope -> { where(source_type: 'ApiClient') }
end
