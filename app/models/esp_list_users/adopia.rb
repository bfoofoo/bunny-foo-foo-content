module EspListUsers
  class Adopia < EmailMarketerListUser
    default_scope -> { where(list_type: 'AdopiaList') }
  end
end
