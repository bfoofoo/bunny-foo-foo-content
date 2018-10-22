module ExportedLeads
  class Maropost < ExportedLead
    default_scope -> { where(list_type: 'MaropostList') }
  end
end
