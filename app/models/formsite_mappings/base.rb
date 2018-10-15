module FormsiteMappings
  class Base < EmailMarketerMapping
    alias_attribute :formsite, :source

    default_scope -> { where(source_type: 'Formsite') }

    validates :destination_id, uniqueness: { scope: :source_id }
  end
end
