module ApiClientMappings
  class Adopia < ApiClientMapping
    default_scope -> { where(destination_type: 'AdopiaList') }
  end
end
