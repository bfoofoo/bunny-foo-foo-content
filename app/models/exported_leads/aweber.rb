module ExportedLeads
  class Aweber < ExportedLead
    default_scope -> { where(list_type: 'AweberList') }
  end
end
