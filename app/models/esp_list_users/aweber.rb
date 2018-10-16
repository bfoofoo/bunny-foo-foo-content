module EspListUsers
  class Aweber < EmailMarketerListUser
    default_scope -> { where(list_type: 'AweberList') }
  end
end
