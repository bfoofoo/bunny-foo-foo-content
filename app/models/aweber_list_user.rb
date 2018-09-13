class AweberListUser < EmailMarketerListUser
  default_scope -> { where(list_type: 'AweberList') }
end
