module FormsiteMappings
  class Adopia < Base
    alias_attribute :adopia_list, :destination

    default_scope -> { by_type('AdopiaList') }
  end
end
