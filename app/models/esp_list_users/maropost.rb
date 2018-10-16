module EspListUsers
  class Maropost < EmailMarketerListUser
    default_scope -> { where(list_type: 'MaropostList') }
  end
end
