module EspRules
    class Website < EspRule
      default_scope { where(source_type: 'Website') }
  
      alias_attribute :website, :source
    end
  end