module ApiClientMappings
  class Aweber < Base
    alias_attribute :aweber_list, :destination

    default_scope -> { by_type('AweberList') }
  end
end
