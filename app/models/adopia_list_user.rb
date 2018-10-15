class AdopiaListUser < EmailMarketerListUser
  default_scope -> { where(list_type: 'AdopiaList') }
end
