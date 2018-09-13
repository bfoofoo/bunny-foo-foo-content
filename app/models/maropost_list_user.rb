class MaropostListUser < EmailMarketerListUser
  default_scope -> { where(list_type: 'MaropostList') }
end
