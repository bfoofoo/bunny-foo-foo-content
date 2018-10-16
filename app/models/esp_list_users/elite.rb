module EspListUsers
  class Elite < EmailMarketerListUser
    default_scope -> { where(list_type: 'EliteList') }
  end
end
