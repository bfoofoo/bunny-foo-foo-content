module FormsiteMappings
  class Adopia < Base
    belongs_to :adopia_list, foreign_key: :destination_id

    default_scope -> { by_type('AdopiaList') }
  end
end
