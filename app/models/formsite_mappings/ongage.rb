module FormsiteMappings
  class Ongage < Base
    belongs_to :ongage_list, foreign_key: :destination_id

    default_scope -> { by_type('OngageList') }
  end
end
