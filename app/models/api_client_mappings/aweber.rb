module ApiClientMappings
  class Aweber < ApiClientMapping
    default_scope -> { where(destination_type: 'AweberList') }
  end
end
