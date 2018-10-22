module ExportedLeads
  class Elite < ExportedLead
    default_scope -> { where(list_type: 'EliteGroup') }
  end
end
