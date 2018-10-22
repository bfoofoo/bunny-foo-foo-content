module ExportedLeads
  class Adopia < ExportedLead
    default_scope -> { where(list_type: 'AdopiaList') }
  end
end
