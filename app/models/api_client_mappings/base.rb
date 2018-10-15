module ApiClientMappings
  class Base < EmailMarketerMapping
    alias_attribute :api_client, :source

    default_scope -> { where(source_type: 'ApiClient') }

    validates :tag, presence: true
    validates :destination_id, uniqueness: { scope: :source_id }
  end
end
