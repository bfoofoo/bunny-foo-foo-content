module FormsiteMappings
  class Elite < Base
    belongs_to :elite_group, foreign_key: :destination_id

    default_scope -> { by_type('EliteGroup') }
  end
end
