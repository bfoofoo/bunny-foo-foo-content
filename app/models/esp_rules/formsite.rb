module EspRules
  class Formsite < EspRule
    default_scope { where(source_type: 'Formsite') }

    alias_attribute :formsite, :source
  end
end
