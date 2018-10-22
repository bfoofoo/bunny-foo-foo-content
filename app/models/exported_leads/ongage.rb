module ExportedLeads
  class Ongage < ExportedLead
    default_scope -> { where(list_type: 'OngageList') }
  end
end
