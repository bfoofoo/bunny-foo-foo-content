module FormsiteMappings
  class Elite < Base
    alias_attribute :elite_group, :destination

    default_scope -> { by_type('EliteGroup') }
  end
end
