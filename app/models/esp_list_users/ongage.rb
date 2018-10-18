module EspListUsers
  class Ongage < EmailMarketerListUser
    default_scope -> { where(list_type: 'OngageList') }
  end
end
