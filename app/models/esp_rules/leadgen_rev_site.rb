module EspRules
  class LeadgenRevSite < EspRule
    default_scope { where(source_type: 'LeadgenRevSite') }

    alias_attribute :leadgen_rev_site, :source
  end
end
