module FormsiteMappings
  class Base < EmailMarketerMapping
    belongs_to :formsite, foreign_key: :source_id

    default_scope -> { where(source_type: 'Formsite') }

    validates :destination_id, uniqueness: { scope: :source_id }
  end
end
