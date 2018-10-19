module FormsiteMappings
  class Aweber < Base
    belongs_to :aweber_list, foreign_key: :destination_id

    default_scope -> { by_type('AweberList') }
  end
end
