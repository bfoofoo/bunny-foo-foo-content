module ApiClientMappings
  class Ongage < Base
    alias_attribute :ongage_list, :destination

    default_scope -> { by_type('OngageList') }
  end
end
